local add, later = MiniDeps.add, MiniDeps.later

later(function() add({ source = "pearofducks/ansible-vim" }) end)
