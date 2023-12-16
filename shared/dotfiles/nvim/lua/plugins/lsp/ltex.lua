local capabilities = require("plugins.lsp.utils").capabilities
local on_attach = require("plugins.lsp.utils").on_attach

require("ltex_extra").setup({
	load_langs = { "en-US", "pt-BR" },
	init_check = false,
	path = vim.fn.expand("~") .. "/.local/state/ltex",
	server_opts = {
		on_attach = on_attach,
		capabilities = capabilities,
		filetypes = { "markdown", "quarto" },
		settings = {
			ltex = {
				language = "auto",
			},
		},
	},
})
