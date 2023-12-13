local capabilities = require("plugins.lsp.utils").capabilities
local map = require("utils").map

local on_attach = function(_, bufnr)
	map({
		mode = { "n", "x" },
		key = "<leader>a",
		command = vim.lsp.buf.code_action,
		buffer = bufnr,
		desc = "LSP: code actions",
	})

	map({
		key = "<leader>d",
		command = "<cmd>TroubleToggle document_diagnostics<cr>",
		buffer = bufnr,
		desc = "LSP: document diagnostics",
	})
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
