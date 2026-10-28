use std/log

# Mirror public GitHub repositories into bare repositories under <root>/<owner>.
def main [
    root: path # directory that holds the gitolite repositories
    ...repos: string # repository names
    --owner (-o): string = "" # GitHub user or organisation, required
]: nothing -> nothing {
    if ($owner | is-empty) {
        error make {
            msg: "--owner is required"
            label: {
                text: "this value is empty"
                span: (metadata $owner).span
            }
        }
    }

    let target = $"($root)/($owner)"

    let results = $repos | par-each --keep-order {|name|
        let dir = $target | path join $"($name).git"
        let result = if ($dir | path exists) {
            git -C $dir fetch --prune origin | complete
        } else {
            git clone --mirror $"https://github.com/($owner)/($name).git" $dir | complete
        }

        {name: $name, exit_code: $result.exit_code, stderr: ($result.stderr | str trim)}
    }

    for result in $results {
        if $result.exit_code != 0 {
            log error $"failed ($result.name): ($result.stderr)"
            continue
        }

        log info $"mirrored ($result.name)"
    }

    if ($results | any {|result| $result.exit_code != 0 }) {
        exit 1
    }
}
