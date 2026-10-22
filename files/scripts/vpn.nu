# Systemd unit that runs the WireGuard tunnel.
const UNIT = "wg-quick-home.service"

# Name of the WireGuard interface.
const INTERFACE = "home"

# Print a WireGuard value of the tunnel, or stop with an error.
def wg-show [
    field: string # value to read, for example transfer
]: nothing -> string {
    let result = sudo wg show $INTERFACE $field | complete

    if $result.exit_code != 0 {
        error make {
            msg: $"wg show ($field) failed: ($result.stderr | str trim)"
            label: {text: "this field", span: (metadata $field).span}
        }
    }

    $result.stdout
}

def is-up []: nothing -> bool {
    let result = systemctl is-active $UNIT | complete

    $result.exit_code == 0
}

# Return the tunnel state, the peer and the traffic.
def "main status" []: nothing -> record {
    if not (is-up) {
        return {state: down, hint: "run `vpn up` to connect"}
    }

    let seen = wg-show latest-handshakes | split row "\t" | last | into int
    let traffic = wg-show transfer | split row "\t" | last 2 | into int | into filesize
    let handshake = if $seen == 0 {
        "never"
    } else {
        let now = date now
        let seen_at = $seen * 1_000_000_000 | into datetime
        let age = $now - $seen_at

        $"(($age | into int) // 1_000_000_000 * 1sec | format duration sec) ago"
    }

    let addresses = ip -4 -o address show dev $INTERFACE | complete

    if $addresses.exit_code != 0 {
        error make {
            msg: $"ip address show failed: ($addresses.stderr | str trim)"
            label: {text: "this output", span: (metadata $addresses).span}
        }
    }

    {
        state: up
        address: ($addresses.stdout | parse --regex 'inet (?<address>\S+)' | get address | first)
        endpoint: (wg-show endpoints | split row "\t" | last)
        handshake: $handshake
        received: ($traffic | first)
        sent: ($traffic | last)
    }
}

# Start the home tunnel.
def "main up" []: nothing -> record {
    if (is-up) {
        return (main status)
    }

    let result = sudo systemctl start $UNIT | complete

    if $result.exit_code != 0 {
        print --stderr $"vpn: could not start the tunnel: ($result.stderr | str trim)"
        exit 1
    }

    main status
}

# Stop the home tunnel.
def "main down" []: nothing -> record {
    if not (is-up) {
        return (main status)
    }

    let result = sudo systemctl stop $UNIT | complete

    if $result.exit_code != 0 {
        print --stderr $"vpn: could not stop the tunnel: ($result.stderr | str trim)"
        exit 1
    }

    main status
}

# Turn the home WireGuard tunnel on or off.
def main []: nothing -> record {
    main status
}
