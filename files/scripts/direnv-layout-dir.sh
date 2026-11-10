direnv_layout_dir() {
    if [[ -f "$PWD/devenv.nix" ]]; then
        echo "$PWD/.devenv/direnv"
        return
    fi

    echo "$PWD/.direnv"
}
