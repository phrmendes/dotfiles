return function(client, bufnr)
	vim.keymap.set("n", "]]", function() Snacks.words.jump(vim.v.count1) end, {
		noremap = true,
		buffer = bufnr,
		desc = "LSP: go to next reference",
	})

	vim.keymap.set("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, {
		noremap = true,
		buffer = bufnr,
		desc = "LSP: go to previous reference",
	})

	if client:supports_method("textDocument/rename", bufnr) then
		vim.keymap.set("n", "<f2>", vim.lsp.buf.rename, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: rename symbol",
		})
	end

	if client:supports_method("textDocument/definition", bufnr) then
		vim.keymap.set("n", "gd", function() MiniExtra.pickers.lsp({ scope = "definition" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: go to definition",
		})
	end

	if client:supports_method("textDocument/declaration", bufnr) then
		vim.keymap.set("n", "gD", function() MiniExtra.pickers.lsp({ scope = "declaration" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: go to declaration",
		})
	end

	if client:supports_method("textDocument/implementation", bufnr) then
		vim.keymap.set("n", "gi", function() MiniExtra.pickers.lsp({ scope = "implementation" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: go to implementations",
		})
	end

	if client:supports_method("textDocument/references", bufnr) then
		vim.keymap.set("n", "gr", function() MiniExtra.pickers.lsp({ scope = "references" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: go to references",
		})
	end

	if client:supports_method("textDocument/typeDefinition", bufnr) then
		vim.keymap.set("n", "gt", function() MiniExtra.pickers.lsp({ scope = "type_definition" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: go to type definition",
		})
	end

	if client:supports_method("textDocument/codeAction", bufnr) then
		vim.keymap.set({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: code actions",
		})
	end

	if client:supports_method("textDocument/publishDiagnostics", bufnr) then
		vim.keymap.set("n", "<leader>d", function() MiniExtra.pickers.diagnostic({ scope = "current" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: diagnostics",
		})

		vim.keymap.set("n", "<leader>D", function() MiniExtra.pickers.diagnostic() end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: workspace diagnostics",
		})

		vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: diagnostics (float)",
		})
	end

	if client:supports_method("textDocument/signatureHelp", bufnr) then
		vim.keymap.set("n", "<leader>h", vim.lsp.buf.signature_help, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: signature help",
		})
	end

	if client:supports_method("textDocument/inlayHint", bufnr) then
		vim.keymap.set("n", "<leader>i", function() Snacks.toggle.inlay_hints() end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: toggle inlay hints",
		})
	end

	if client:supports_method("textDocument/hover", bufnr) then
		vim.keymap.set("n", "K", vim.lsp.buf.hover, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: hover",
		})
	end

	if client:supports_method("textDocument/documentSymbol", bufnr) then
		vim.keymap.set("n", "<leader>s", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: symbols (document)",
		})
	end

	if client:supports_method("workspace/symbol", bufnr) then
		vim.keymap.set("n", "<leader>S", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: symbols (workspace)",
		})
	end
end
