curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

omf theme agnoster

omf install foreign-env

set fish_function_path $fish_function_path ~/plugin-foreign-env/functions

fenv source ~/.nix-profile/etc/profile.d/nix.sh

"fenv source ~/.nix-profile/etc/profile.d/nix.sh" >> ~/.config/fish/config.fish

find ~/.nix-profile/share/applications -type l -exec ln -s ~/{} ~/.local/share/applications \;

# fish path: /home/"$USER"/.nix-profile/bin/fish