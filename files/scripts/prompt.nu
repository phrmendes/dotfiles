const FETCH_INTERVAL = 10min

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

# Commits to pull and to push, counted against every remote ref as of the last fetch. Nothing without a remote.
def sync-counts []: nothing -> oneof<record, nothing> {
    let refs = git for-each-ref --format "%(refname:short)" refs/remotes | complete

    if $refs.exit_code != 0 {
        return null
    }

    let counts = (
        $refs.stdout
        | lines
        | where not ($it | str ends-with "/HEAD")
        | each {|ref|
            let result = git rev-list --left-right --count $"($ref)...HEAD" | complete

            if $result.exit_code != 0 {
                return null
            }

            let counts = $result.stdout | str trim | split row "\t" | into int
            {behind: ($counts | first), ahead: ($counts | last)}
        }
        | compact
    )

    if ($counts | is-empty) {
        return null
    }

    {
        behind: ($counts | get behind | math max)
        ahead: ($counts | get ahead | math max)
    }
}

# Fetch the upstream in the background when the last fetch is older than the interval.
def fetch-when-stale []: nothing -> nothing {
    let result = git rev-parse --absolute-git-dir | complete

    if $result.exit_code != 0 {
        return
    }

    let gitdir = $result.stdout | str trim
    let marker = $gitdir | path join prompt-fetch
    let newest = [FETCH_HEAD prompt-fetch]
    | each {|name| $gitdir | path join $name }
    | where ($it | path exists)
    | each {|path| try { ls --long $path | get modified | first } }
    | compact
    | sort
    | last 1

    if ($newest | is-not-empty) {
        let age = date now | $in - ($newest | first)

        if $age < $FETCH_INTERVAL {
            return
        }
    }

    try { touch $marker }

    job spawn --description "fetch the upstream for the prompt" {
        let ok_marker = $gitdir | path join prompt-fetch-ok
        let fail_marker = $gitdir | path join prompt-fetch-fail
        let status = (
            try {
                with-env {GIT_TERMINAL_PROMPT: "0", GIT_SSH_COMMAND: "ssh -o BatchMode=yes"} {
                    ^git --git-dir $gitdir fetch --quiet --no-tags | complete | get exit_code
                }
            } catch { 1 }
        )

        rm -f $fail_marker
        if $status == 0 { touch $ok_marker } else { touch $fail_marker }
    } | ignore
}

# Age of the last successful fetch, and a red ! when the last attempt failed.
def fetch-age-prompt []: nothing -> string {
    let result = git rev-parse --absolute-git-dir | complete

    if $result.exit_code != 0 {
        return ""
    }

    let gitdir = $result.stdout | str trim
    let ok_marker = $gitdir | path join prompt-fetch-ok
    let fail_marker = $gitdir | path join prompt-fetch-fail
    let warning = if ($fail_marker | path exists) { " (ansi red_bold)!(ansi reset)" } else { "" }

    if not ($ok_marker | path exists) {
        return $warning
    }

    let modified = try {
        ls --long $ok_marker | get modified | first
    } catch { return $warning }
    let secs = (date now | $in - $modified | into int) / 1_000_000_000
    let age = if $secs >= 3600 {
        $"($secs / 3600 | math floor)h"
    } else if $secs >= 60 {
        $"($secs / 60 | math floor)m"
    } else {
        "<1m"
    }
    $" (ansi dark_gray)($age)(ansi reset)($warning)"
}

# Commits to push (up arrow) and to pull (down arrow). Starts a background fetch when the data is stale.
def git-sync-prompt []: nothing -> string {
    let counts = sync-counts

    if $counts == null {
        return ""
    }

    fetch-when-stale

    let ahead = if $counts.ahead > 0 { $" (ansi cyan_bold)↑($counts.ahead)(ansi reset)" } else { "" }
    let behind = if $counts.behind > 0 { $" (ansi yellow_bold)↓($counts.behind)(ansi reset)" } else { "" }

    $"($ahead)($behind)"
}

load-env {
    PROMPT_COMMAND: {|| $"(ssh-host-prompt)(basic-git-left-prompt (cwd-prompt))(git-sync-prompt)(fetch-age-prompt)(char newline)" }
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
