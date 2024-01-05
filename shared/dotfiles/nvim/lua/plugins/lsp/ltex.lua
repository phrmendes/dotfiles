local utils = require("utils")

require("ltex_extra").setup({
	load_langs = { "en-US", "pt-BR" },
	init_check = false,
	path = vim.fn.expand("~") .. "/.local/state/ltex",
	server_opts = {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		on_attach = utils.on_attach,
		filetypes = { "markdown", "quarto" },
		settings = {
			ltex = {
				language = "auto",
			},
		},
	},
})
