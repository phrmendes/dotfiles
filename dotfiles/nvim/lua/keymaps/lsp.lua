return function(client, bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "LSP: go to next reference"
	vim.keymap.set("n", "]]", function() Snacks.words.jump(vim.v.count1) end, opts)

	opts.desc = "LSP: go to previous reference"
	vim.keymap.set("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, opts)

	if client:supports_method("textDocument/rename", bufnr) then
		opts.desc = "LSP: rename symbol"
		vim.keymap.set("n", "<f2>", vim.lsp.buf.rename, opts)
	end

	if client:supports_method("textDocument/definition", bufnr) then
		opts.desc = "LSP: go to definition"
		vim.keymap.set("n", "gd", function() MiniExtra.pickers.lsp({ scope = "definition" }) end, opts)
	end

	if client:supports_method("textDocument/declaration", bufnr) then
		opts.desc = "LSP: go to declaration"
		vim.keymap.set("n", "gD", function() MiniExtra.pickers.lsp({ scope = "declaration" }) end, opts)
	end

	if client:supports_method("textDocument/implementation", bufnr) then
		opts.desc = "LSP: go to implementations"
		vim.keymap.set("n", "gi", function() MiniExtra.pickers.lsp({ scope = "implementation" }) end, opts)
	end

	if client:supports_method("textDocument/references", bufnr) then
		opts.desc = "LSP: go to references"
		vim.keymap.set("n", "gr", function() MiniExtra.pickers.lsp({ scope = "references" }) end, opts)
	end

	if client:supports_method("textDocument/typeDefinition", bufnr) then
		opts.desc = "LSP: go to type definition"
		vim.keymap.set("n", "gt", function() MiniExtra.pickers.lsp({ scope = "type_definition" }) end, opts)
	end

	if client:supports_method("textDocument/codeAction", bufnr) then
		opts.desc = "LSP: code actions"
		vim.keymap.set({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, opts)
	end

	if client:supports_method("textDocument/publishDiagnostics", bufnr) then
		opts.desc = "LSP: diagnostics"
		vim.keymap.set("n", "<leader>d", function() MiniExtra.pickers.diagnostic({ scope = "current" }) end, opts)

		opts.desc = "LSP: workspace diagnostics"
		vim.keymap.set("n", "<leader>D", function() MiniExtra.pickers.diagnostic() end, opts)

		opts.desc = "LSP: diagnostics (float)"
		vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, opts)
	end

	if client:supports_method("textDocument/signatureHelp", bufnr) then
		opts.desc = "LSP: signature help"
		vim.keymap.set("n", "<leader>h", vim.lsp.buf.signature_help, opts)
	end

	if client:supports_method("textDocument/inlayHint", bufnr) then
		opts.desc = "LSP: toggle inlay hints"
		vim.keymap.set("n", "<leader>i", function() Snacks.toggle.inlay_hints() end, opts)
	end

	if client:supports_method("textDocument/hover", bufnr) then
		opts.desc = "LSP: hover"
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	end

	if client:supports_method("textDocument/documentSymbol", bufnr) then
		opts.desc = "LSP: symbols (document)"
		vim.keymap.set("n", "<leader>s", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end, opts)
	end

	if client:supports_method("workspace/symbol", bufnr) then
		opts.desc = "LSP: symbols (workspace)"
		vim.keymap.set("n", "<leader>S", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end, opts)
	end
end
