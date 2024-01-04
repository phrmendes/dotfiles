local utils = require("utils")

require("ltex_extra").setup({
	load_langs = { "en-US", "pt-BR" },
	init_check = false,
	path = vim.fn.expand("~") .. "/.local/state/ltex",
	server_opts = {
		on_attach = function(_, bufnr)
			utils.map({
				mode = { "n", "v" },
				key = "<leader>a",
				command = vim.lsp.buf.code_action,
				buffer = bufnr,
				desc = "LSP: code actions",
			})

			utils.map({
				key = "<leader>d",
				command = "<cmd>TroubleToggle document_diagnostics<cr>",
				buffer = bufnr,
				desc = "LSP: document diagnostics",
			})
		end,
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		filetypes = { "markdown", "quarto" },
		settings = {
			ltex = {
				language = "auto",
			},
		},
	},
})
