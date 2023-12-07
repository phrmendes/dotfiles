local M = {}

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.on_attach = function(_, bufnr)
	local map = function(key, value, desc, type)
		if type == nil then
			type = "n"
		end

		vim.keymap.set(type, key, value, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	map("<leader>D", "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace diagnostics")
	map("<leader>F", vim.diagnostic.open_float, "floating diagnostics")
	map("<leader>S", "<cmd>Telescope lsp_workspace_symbols<cr>", "workspace symbols")
	map("<leader>a", vim.lsp.buf.code_action, "code actions", { "n", "x" })
	map("<leader>d", "<cmd>TroubleToggle document_diagnostics<cr>", "document diagnostics")
	map("<leader>h", vim.lsp.buf.signature_help, "show signature help")
	map("<leader>k", vim.lsp.buf.hover, "show hover documentation")
	map("<leader>r", vim.lsp.buf.rename, "rename symbol")
	map("<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", "document symbols")
	map("gD", vim.lsp.buf.declaration, "go to declaration")
	map("gd", "<cmd>Telescope lsp_definitions<CR>", "go to definition")
	map("gi", "<cmd>Telescope lsp_implementations<cr>", "go to implementations")
	map("gr", "<cmd>Telescope lsp_references<cr>", "go to references")
	map("gt", "<cmd>Telescope lsp_type_definitions<cr>", "go to type definition")
end

return M
