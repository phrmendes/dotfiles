#!/bin/bash

sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume

touch .zshrc

sudo cat <<EOF >> $HOME/.zshrc
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
EOF
