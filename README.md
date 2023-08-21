# Backups

Scripts and dotfiles files for my personal computer.

## How to use

Install requirements:

```sh
sudo apt update
sudo apt install aptitude build-essential ca-certificates flatpak git gnupg python3-apt python3-pip python3-pycurl python3-setuptools
/usr/bin/pip -m pip install ansible
```

Run playbook:

```sh
curl https://raw.githubusercontent.com/phrmendes/bkps/popOS/playbook.yml > /tmp/playbook.yml
/usr/bin/python3 -m ansible playbook /tmp/playbook.yml --ask-become-pass
```

## References

- <https://docs.ansible.com/>
- <https://github.com/uunicorn/python-validity>
- <https://nixos.wiki/wiki/Home_Manager>
- <https://nixos.wiki/wiki/Nix_package_manager>
- <https://pop.system76.com/>
