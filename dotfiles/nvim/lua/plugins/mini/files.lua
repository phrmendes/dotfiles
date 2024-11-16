require("mini.files").setup({
	mappings = {
		close = "q",
		go_in = "<tab>",
		go_in_plus = "<cr>",
		go_out = "<s-tab>",
		go_out_plus = "H",
		reset = "<del>",
		reveal_cwd = "@",
		show_help = "?",
		synchronize = "=",
		trim_left = "<",
		trim_right = ">",
	},
})

vim.g.mini_show_dotfiles = true
