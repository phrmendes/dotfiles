local M = {}
local map = require("utils").map

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.on_attach = function(_, bufnr)
	map({
		key = "<leader>D",
		command = "<cmd>TroubleToggle workspace_diagnostics<cr>",
		buffer = bufnr,
		desc = "LSP: workspace diagnostics",
	})

	map({
		key = "<leader>F",
		command = vim.diagnostic.open_float,
		buffer = bufnr,
		desc = "LSP: floating diagnostics",
	})

	map({
		key = "<leader>S",
		command = "<cmd>Telescope lsp_workspace_symbols<cr>",
		buffer = bufnr,
		desc = "LSP: workspace symbols",
	})

	map({
		mode = { "n", "v" },
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

	map({
		key = "<leader>h",
		command = vim.lsp.buf.signature_help,
		buffer = bufnr,
		desc = "LSP: show signature help",
	})

	map({
		key = "<leader>k",
		command = vim.lsp.buf.hover,
		buffer = bufnr,
		desc = "LSP: show hover documentation",
	})

	map({
		key = "<leader>r",
		command = vim.lsp.buf.rename,
		buffer = bufnr,
		desc = "LSP: rename symbol",
	})

	map({
		key = "<leader>s",
		command = "<cmd>Telescope lsp_document_symbols<cr>",
		buffer = bufnr,
		desc = "LSP: document symbols",
	})

	map({
		key = "gD",
		command = vim.lsp.buf.declaration,
		buffer = bufnr,
		desc = "LSP: go to declaration",
	})

	map({
		key = "gd",
		command = "<cmd>Telescope lsp_definitions<CR>",
		buffer = bufnr,
		desc = "LSP: go to definition",
	})

	map({
		key = "gi",
		command = "<cmd>Telescope lsp_implementations<cr>",
		buffer = bufnr,
		desc = "LSP: go to implementations",
	})

	map({
		key = "gr",
		command = "<cmd>Telescope lsp_references<cr>",
		buffer = bufnr,
		desc = "LSP: go to references",
	})

	map({
		key = "gt",
		command = "<cmd>Telescope lsp_type_definitions<cr>",
		buffer = bufnr,
		desc = "LSP: go to type definition",
	})
end

return M
