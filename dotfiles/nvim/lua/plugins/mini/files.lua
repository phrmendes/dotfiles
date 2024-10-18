require("mini.files").setup({
	mappings = {
		close = "q",
		go_in = "l",
		go_in_plus = "<cr>",
		go_out = "h",
		go_out_plus = "<bs>",
		reset = "<del>",
		reveal_cwd = "@",
		show_help = "?",
		synchronize = "=",
		trim_left = "<",
		trim_right = ">",
	},
})

vim.g.mini_show_dotfiles = true
