if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias ls="exa --icons"
alias cat="bat"

set -gx STARSHIP_CONFIG "$HOME"/.config/starship/starship.toml
alias stow_dotfiles="stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles"
starship init fish | source
