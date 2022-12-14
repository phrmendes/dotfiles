#!/bin/bash

sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume

sudo cat <<EOF >> /etc/zshrc
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
EOF
