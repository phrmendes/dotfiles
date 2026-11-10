def devenv-root []: nothing -> string {
    mut dir = $env.PWD

    while $dir != ($dir | path dirname) {
        if ($dir | path join "devenv.nix" | path exists) {
            return $dir
        }

        $dir = ($dir | path dirname)
    }

    ""
}

def devenv-envrc []: nothing -> nothing {
    let projects = $env.PROJECTS_DIR? | default ""

    if ($projects | is-empty) {
        return
    }

    let root = (devenv-root)

    if ($root | is-empty) or not ($root | str starts-with $projects) {
        return
    }

    let envrc = $root | path join ".envrc"

    if ($envrc | path exists) {
        return
    }

    print -e $"devenv: writing ($envrc)"
    'eval "$(devenv direnvrc)"' + (char nl) + "use devenv" + (char nl) | save $envrc
}

$env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | default [] | append {|| devenv-envrc })
