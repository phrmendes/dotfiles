local map = require("utils.keybindings").map
local files = require("mini.files")

files.setup({
	mappings = {
		close = "q",
		go_in = "<TAB>",
		go_in_plus = "<CR>",
		go_out = "<S-TAB>",
		go_out_plus = "<BS>",
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
	cmd = function()
		files.open(vim.api.nvim_buf_get_name(0), true)
	end,
	desc = "Open file explorer (cwd)",
})

map({
	key = "<leader>E",
	cmd = function()
		files.open(vim.loop.cwd(), true)
	end,
	desc = "Open file explorer (root)",
})
