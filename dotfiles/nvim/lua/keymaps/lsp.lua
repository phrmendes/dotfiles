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

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_rename, bufnr) then
		vim.keymap.set("n", "<f2>", vim.lsp.buf.rename, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: rename symbol",
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_definition, bufnr) then
		vim.keymap.set("n", "gd", function() MiniExtra.pickers.lsp({ scope = "definition" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: go to definition",
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_declaration, bufnr) then
		vim.keymap.set("n", "gD", function() MiniExtra.pickers.lsp({ scope = "declaration" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: go to declaration",
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_implementation, bufnr) then
		vim.keymap.set("n", "gi", function() MiniExtra.pickers.lsp({ scope = "implementation" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: go to implementations",
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_references, bufnr) then
		vim.keymap.set("n", "gr", function() MiniExtra.pickers.lsp({ scope = "references" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: go to references",
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_typeDefinition, bufnr) then
		vim.keymap.set("n", "gt", function() MiniExtra.pickers.lsp({ scope = "type_definition" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: go to type definition",
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeAction, bufnr) then
		vim.keymap.set({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: code actions",
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_publishDiagnostics, bufnr) then
		vim.keymap.set("n", "<leader>d", function() MiniExtra.pickers.diagnostic({ scope = "current" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: diagnostics",
		})

		vim.keymap.set("n", "<leader>D", function() MiniExtra.pickers.diagnostic({ scope = "all" }) end, {
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

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_signatureHelp, bufnr) then
		vim.keymap.set({ "n", "x" }, "<leader>h", vim.lsp.buf.signature_help, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: signature help",
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
		vim.keymap.set("n", "<leader>i", function() Snacks.toggle.inlay_hints() end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: toggle inlay hints",
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_hover, bufnr) then
		vim.keymap.set("n", "K", vim.lsp.buf.hover, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: hover",
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol, bufnr) then
		vim.keymap.set("n", "<leader>s", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: symbols (document)",
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.workspace_symbol, bufnr) then
		vim.keymap.set("n", "<leader>S", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: symbols (workspace)",
		})
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
		vim.keymap.set("i", "<c-l>", vim.lsp.inline_completion.get, {
			desc = "LSP: accept inline completion",
			buffer = bufnr,
		})

		vim.keymap.set("i", "<c-]>", vim.lsp.inline_completion.select, {
			desc = "LSP: next inline completion",
			buffer = bufnr,
		})
	end

	if
		client:supports_method(vim.lsp.protocol.Methods.workspace_didRenameFiles, bufnr)
		or client:supports_method(vim.lsp.protocol.Methods.workspace_willRenameFiles, bufnr)
	then
		vim.keymap.set("n", "<leader>R", function() Snacks.rename.rename_file() end, {
			noremap = true,
			buffer = bufnr,
			desc = "LSP: rename file",
		})
	end
end
