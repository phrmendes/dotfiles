require("quicker").setup()

require("bqf").setup({
	func_map = {
		drop = "o",
		open = "<cr>",
		openc = "<c-cr>",
		split = "<c-->",
		vsplit = "<c-\\>",
		tabc = "",
		tabdrop = "<c-t>",
	},
	filter = {
		fzf = {
			action_for = {
				["ctrl-t"] = "tabedit",
				["ctrl--"] = "vsplit",
				["ctrl-\\"] = "split",
				["ctrl-c"] = "closeall",
			},
			extra_opts = {
				description = "Extra options for fzf",
				default = { "--bind", "ctrl-a:toggle-all" },
			},
		},
	},
})
