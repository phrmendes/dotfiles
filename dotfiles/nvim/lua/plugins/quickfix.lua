require("bqf").setup({
	func_map = {
		drop = "o",
		open = "<cr>",
		openc = "<c-cr>",
		split = "<c-s>",
		tabc = "",
		tabdrop = "<c-t>",
	},
	filter = {
		fzf = {
			action_for = {
				["ctrl-t"] = {
					description = [[Press ctrl-t to open up the item in a new tab]],
					default = "tabedit",
				},
				["ctrl-v"] = {
					description = [[Press ctrl-v to open up the item in a new vertical split]],
					default = "vsplit",
				},
				["ctrl-s"] = {
					description = [[Press ctrl-s to open up the item in a new horizontal split]],
					default = "split",
				},
				["ctrl-c"] = {
					description = [[Press ctrl-c to close quickfix window and abort fzf]],
					default = "closeall",
				},
			},
			extra_opts = {
				description = "Extra options for fzf",
				default = { "--bind", "ctrl-a:toggle-all" },
			},
		},
	},
})
