# Restore the latest snapshot of a repository into a temporary directory and verify it.
def main [
    name: string # repository name, as used by restic-<name>
    root: string # parent directory of the temporary restore
]: nothing -> nothing {
    let target = (^mktemp -d $"($root)/restic-restore-($name).XXXXXX" | str trim)
    try {
        ^$"restic-($name)" restore latest --target $target --verify
    } finally {
        rm -rf $target
    }
}
