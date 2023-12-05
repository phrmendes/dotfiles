local capabilities = require("plugins.lsp.utils").capabilities

local map = vim.keymap.set

local on_attach = function()
	map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, { desc = "LSP: code actions" })
	map("n", "<leader>d", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "LSP: document diagnostics" })
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
