local wk = require("which-key")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(_, bufnr)
	wk.register({
		name = "code",
		a = { vim.lsp.buf.code_action, "Actions" },
	}, { prefix = "<leader>c", mode = { "n", "x" }, buffer = bufnr })

	wk.register({
		name = "debug/diagnostics",
		d = { "<cmd>TroubleToggle document_diagnostics<cr>", "LSP: document diagnostics" },
	}, { prefix = "<leader>d", mode = "n", buffer = 0 })
end

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
