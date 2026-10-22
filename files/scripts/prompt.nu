# Current directory, shortened, with a marker when it is read-only.
def cwd-prompt []: nothing -> string {
    let directory = (
        path_abbrev_if_needed (home_abbrev $nu.os-info.name) (term size).columns
        | ansi strip
    )

    let directory = match $directory {
        "~/" => "~"
        /~ => "~"
        _ => $directory
    }

    let permissions = (
        try {
            stat -c %A $env.PWD | str trim
        } catch { null }
    )

    let read_only = if $permissions == null {
        false
    } else {
        ($permissions | str substring 2..2) != w
    }

    let marker = if $read_only { $" (ansi yellow)[ro](ansi reset)" } else { "" }

    $"(ansi cyan_bold)($directory)(ansi reset)($marker)"
}

# Duration of the last command, shown only when it took 2 seconds or more.
def duration-prompt []: nothing -> string {
    let duration = $env.CMD_DURATION_MS? | default 0 | into int
    if $duration < 2000 {
        ""
    } else {
        let seconds = $duration / 1000 | math round --precision 1
        $" (ansi yellow)($seconds)s(ansi reset)"
    }
}

# Prompt symbol: purple in normal mode, green after success, red after failure.
def lambda-prompt [
    mode: string = "insert" # editing mode: insert, or normal in vi mode
]: nothing -> string {
    let exit_code = $env.LAST_EXIT_CODE? | default 0 | into int

    let color = match [$mode $exit_code] {
        [normal, _] => "purple"
        [_, 0] => "green"
        _ => "red"
    }

    $"(ansi $color)λ(ansi reset)(duration-prompt) "
}

# The user and host name, shown only inside an SSH session.
def ssh-host-prompt []: nothing -> string {
    if $env.SSH_CONNECTION? == null {
        ""
    } else {
        $"(ansi magenta_bold)(whoami)@(sys host | get hostname)(ansi reset) "
    }
}

load-env {
    PROMPT_COMMAND: {|| $"(ssh-host-prompt)(basic-git-left-prompt (cwd-prompt))(char newline)" }
    PROMPT_COMMAND_RIGHT: {|| "" }
    PROMPT_INDICATOR: {|| lambda-prompt }
    PROMPT_INDICATOR_VI_INSERT: {|| lambda-prompt }
    PROMPT_INDICATOR_VI_NORMAL: {|| lambda-prompt normal }
    TRANSIENT_PROMPT_COMMAND: "",
    TRANSIENT_PROMPT_COMMAND_RIGHT: "",
    TRANSIENT_PROMPT_INDICATOR: {|| lambda-prompt }
    TRANSIENT_PROMPT_INDICATOR_VI_INSERT: {|| lambda-prompt }
    TRANSIENT_PROMPT_INDICATOR_VI_NORMAL: {|| lambda-prompt normal }
}

$env.config.menus = (
    $env.config.menus
    | each {|menu|
        if $menu.name in [completion_menu ide_completion_menu] {
            $menu | upsert marker "λ "
        } else {
            $menu
        }
    }
)
