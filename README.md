# Backups

Scripts and dotfiles files for my personal computer.

## How to use

```sh
sudo apt install python3-apt python3-pycurl python3-setuptools
/usr/bin/pip -m pip install ansible
curl https://raw.githubusercontent.com/phrmendes/bkps/popOS/playbook.yml > /tmp/playbook.yml
ansible-playbook /tmp/playbook.yml --ask-become-pass
```

## References

- <https://docs.ansible.com/>
- <https://github.com/uunicorn/python-validity>
- <https://nixos.wiki/wiki/Home_Manager>
- <https://nixos.wiki/wiki/Nix_package_manager>
- <https://pop.system76.com/>
