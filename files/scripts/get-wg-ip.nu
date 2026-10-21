use lib.nu fail

# Print the WireGuard interfaces of this machine as JSON: [{"interface": "wg0", "addresses": ["10.8.0.2"]}].
def main []: nothing -> string {
    let links = ip -j link show type wireguard | complete

    if $links.exit_code != 0 {
        fail $"Cannot list the WireGuard interfaces: ($links.stderr | str trim)"
    }

    let names = try {
        $links.stdout | from json | get ifname
    } catch {
        fail "Cannot read the WireGuard interfaces: ip printed invalid JSON"
    }

    mut interfaces = []

    for name in $names {
        let result = ip -j -4 addr show dev $name | complete

        if $result.exit_code != 0 {
            fail $"Cannot read the addresses of ($name): ($result.stderr | str trim)"
        }

        let addresses = try {
            $result.stdout | from json | get addr_info | flatten | get local
        } catch {
            fail $"Cannot read the addresses of ($name): ip printed invalid JSON"
        }

        $interfaces ++= [
            {interface: $name, addresses: $addresses}
        ]
    }

    $interfaces | to json --raw
}
