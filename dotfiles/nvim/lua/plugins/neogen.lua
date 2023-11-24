local neogen = require("neogen")
local wk = require("which-key")

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

wk.register({
	n = { "<cmd>Neogen<cr>", "Generate annotations" },
}, { prefix = "<leader>", mode = "n" })
