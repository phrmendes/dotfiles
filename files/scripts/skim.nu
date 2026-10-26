# Pick files with skim and append them, quoted, to the command line.
def skim-files []: nothing -> nothing {
    let files = (
        try { ls --all **/* } catch {|err|
            if ($err.msg | str starts-with 'No matches found') {
                []
            } else {
                error make $err
            }
        }
    )

    if ($files | is-empty) {
        return
    }

    let picked = (
        $files
        | where type == file
        | where name !~ '(^|/)\.git/'
        | get name
        | str join (char nl)
        | ^sk --multi --height 50% --reverse --preview 'bat --color=always {}'
        | lines
        | each {|path| $path | to nuon }
        | str join ' '
    )

    if ($picked | is-not-empty) {
        commandline edit --append $'($picked) '
        commandline set-cursor --end
    }
}

$env.config.keybindings ++= [
    {
        name: skim_files
        modifier: control
        keycode: char_t
        mode: [vi_insert vi_normal]
        event: {send: executehostcommand, cmd: "skim-files"}
    }
]
