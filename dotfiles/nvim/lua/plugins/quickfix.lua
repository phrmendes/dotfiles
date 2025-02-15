return {
	"kevinhwang91/nvim-bqf",
	event = "VeryLazy",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		func_map = {
			drop = "o",
			open = "<cr>",
			openc = "<c-cr>",
			split = "<c-->",
			vsplit = "<c-\\>",
			tabc = "",
			tabdrop = "<c-t>",
		},
	},
}
