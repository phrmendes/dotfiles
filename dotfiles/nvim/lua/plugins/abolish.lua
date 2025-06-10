local add, later = MiniDeps.add, MiniDeps.later

later(function() add({ source = "tpope/vim-abolish" }) end)
