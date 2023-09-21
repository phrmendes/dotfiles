# Backups

Scripts and dotfiles files for my personal computer.

## How to use

Install requirements:

```sh
sudo apt update
sudo apt install git python3-apt python3-pip python3-pycurl python3-setuptools python3-openssl
pip install --user ansible
```

Clone `bkps` repository:

```sh
git clone https://github.com/phrmendes/bkps.git
```

Run playbook inside the `bkps` repository:

```sh
ansible-playbook playbook.yml --ask-become-pass
```

## References

- <https://docs.ansible.com/>
- <https://github.com/uunicorn/python-validity>
- <https://mutschler.dev/linux/pop-os-btrfs-22-04/>
- <https://nixos.wiki/wiki/Flakes>
- <https://nixos.wiki/wiki/Home_Manager>
- <https://nixos.wiki/wiki/Nix_package_manager>
- <https://pop.system76.com/>
