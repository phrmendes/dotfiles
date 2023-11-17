local cmp_nvim_lsp = require("cmp_nvim_lsp")
local ltex_extra = require("ltex_extra")

local capabilities = cmp_nvim_lsp.default_capabilities()

ltex_extra.setup({
	load_langs = { "en-US", "pt-BR" },
	init_check = true,
	path = vim.fn.expand("~") .. "/.local/state/ltex",
	server_opts = {
		filetypes = { "markdown" },
		capabilities = capabilities,
		settings = {
			ltex = {
				language = "auto",
			},
		},
	},
})
