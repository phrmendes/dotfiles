use lib.nu fail

# Copy a live SQLite database to <destination> as a consistent snapshot, and check the copy.
def main [
    source: path # the database to copy
    destination: path # where the copy goes; an existing file is replaced
]: nothing -> nothing {
    if not ($source | path exists) {
        fail $"The database ($source) does not exist." $source
    }

    let folder = $destination | path dirname

    try {
        mkdir $folder
        chmod 0700 $folder
        rm --force $destination
    } catch {
        fail $"Cannot prepare ($folder)." $destination
    }

    try {
        open $source | query db $"VACUUM INTO '($destination)'"
    } catch {
        fail $"Cannot copy ($source): it is not a readable SQLite database." $source
    }

    let verdict = try {
        open $destination | query db "pragma integrity_check" | get integrity_check | first
    } catch {
        fail $"Cannot read the copy of ($source)." $source
    }

    if $verdict != ok {
        fail $"The copy of ($source) failed the integrity check: ($verdict)" $source
    }
}
