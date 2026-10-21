use std/log

const UNIT = "wg-quick-home.service"

# Show whether the home tunnel is up.
def "main status" []: nothing -> nothing {
    let result = systemctl is-active $UNIT | complete

    if $result.exit_code != 0 {
        log info "home tunnel: inactive"
        return
    }

    log info "home tunnel: active"
    sudo wg show home
}

# Start the home tunnel.
def "main up" []: nothing -> nothing {
    let result = sudo systemctl start $UNIT | complete

    if $result.exit_code != 0 {
        log error $"could not start the tunnel: ($result.stderr | str trim)"
        exit 1
    }

    main status
}

# Stop the home tunnel.
def "main down" []: nothing -> nothing {
    let result = sudo systemctl stop $UNIT | complete

    if $result.exit_code != 0 {
        log error $"could not stop the tunnel: ($result.stderr | str trim)"
        exit 1
    }

    main status
}

# Turn the home WireGuard tunnel on or off.
def main []: nothing -> nothing {
    main status
}
