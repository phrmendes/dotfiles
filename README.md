# Backups

Scripts and dotfiles files for my personal computer.

## How to use

```sh
sudo apt install pipx wget
pipx install --include-deps ansible
wget -O /tmp/playbook.yml https://raw.githubusercontent.com/phrmendes/bkps/popOS/playbook.yml
ansible-playbook /tmp/playbook.yml --ask-become-pass
```

## References

- <https://docs.ansible.com/>
- <https://github.com/uunicorn/python-validity>
- <https://nixos.wiki/wiki/Home_Manager>
- <https://nixos.wiki/wiki/Nix_package_manager>
- <https://pop.system76.com/>
