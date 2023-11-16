local neogen = require("neogen")

local map = vim.keymap.set

neogen.setup({
	snippet_engine = "luasnip",
	enabled = true,
	languages = {
		python = {
			template = {
				annotation_convention = "numpydoc",
			},
		},
	},
})

map("n", "<Leader>n", "<cmd>Neogen<cr>", { desc = "Generate annotations", noremap = true, silent = true })
