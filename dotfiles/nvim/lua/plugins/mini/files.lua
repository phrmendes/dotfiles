local map = require("utils.keybindings").map
local files = require("mini.files")

files.setup({
	mappings = {
		close = "q",
		go_in = "l",
		go_in_plus = "<TAB>",
		go_out = "h",
		go_out_plus = "<S-TAB>",
		reset = "<BS>",
		reveal_cwd = "@",
		show_help = "g?",
		synchronize = "=",
		trim_left = "<",
		trim_right = ">",
	},
})

map({
	key = "<leader>e",
	cmd = files.open,
	desc = "Open file explorer",
})
