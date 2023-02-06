if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

export PATH=$HOME/.local/bin:$PATH
export EDITOR=vim
export VISUAL=vim
eval "$(starship init zsh)"
source ~/.iterm2_shell_integration.zsh
