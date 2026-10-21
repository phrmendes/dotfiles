const UNIT = "wg-quick-home.service"
const INTERFACE = "home"

def is-up []: nothing -> bool {
    let result = systemctl is-active $UNIT | complete

    $result.exit_code == 0
}

# Return the tunnel state, the peer and the traffic.
def "main status" []: nothing -> record {
    if not (is-up) {
        return {state: down, hint: "run `vpn up` to connect"}
    }

    let seen = sudo wg show $INTERFACE latest-handshakes | split row "\t" | last | into int
    let traffic = sudo wg show $INTERFACE transfer | split row "\t" | last 2 | into int | into filesize
    let handshake = if $seen == 0 {
        "never"
    } else {
        let age = (date now) - ($seen * 1_000_000_000 | into datetime)

        $"(($age | into int) // 1_000_000_000 * 1sec | format duration sec) ago"
    }

    {
        state: up
        address: (ip -4 -o address show dev $INTERFACE | parse --regex 'inet (?<address>\S+)' | get address | first)
        endpoint: (sudo wg show $INTERFACE endpoints | split row "\t" | last)
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
