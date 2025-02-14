return {
	setup = function(client, bufnr)
		local opts = { noremap = true, buffer = bufnr }

		opts.desc = "LSP: go to next reference"
		vim.keymap.set("n", "]]", function() Snacks.words.jump(vim.v.count1) end, opts)

		opts.desc = "LSP: go to previous reference"
		vim.keymap.set("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, opts)

		if client.supports_method("textDocument/rename") then
			opts.desc = "LSP: rename symbol"
			vim.keymap.set("n", "<f2>", vim.lsp.buf.rename, opts)
		end

		if client.supports_method("textDocument/definition") then
			opts.desc = "LSP: go to definition"
			vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, opts)
		end

		if client.supports_method("textDocument/declaration") then
			opts.desc = "LSP: go to declaration"
			vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, opts)
		end

		if client.supports_method("textDocument/implementation") then
			opts.desc = "LSP: go to implementations"
			vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, opts)
		end

		if client.supports_method("textDocument/references") then
			opts.desc = "LSP: go to references"
			vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, opts)
		end

		if client.supports_method("textDocument/typeDefinition") then
			opts.desc = "LSP: go to type definition"
			vim.keymap.set("n", "gt", function() Snacks.picker.lsp_type_definitions() end, opts)
		end

		if client.supports_method("textDocument/codeAction") then
			opts.desc = "LSP: code actions"
			vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
		end

		if client.supports_method("textDocument/publishDiagnostics") then
			opts.desc = "LSP: diagnostics"
			vim.keymap.set("n", "<leader>d", function() Snacks.picker.diagnostics_buffer() end, opts)

			opts.desc = "LSP: workspace diagnostics"
			vim.keymap.set("n", "<leader>d", function() Snacks.picker.diagnostics() end, opts)

			opts.desc = "LSP: diagnostics (float)"
			vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, opts)
		end

		if client.supports_method("textDocument/signatureHelp") then
			opts.desc = "LSP: signature help"
			vim.keymap.set("n", "<leader>h", vim.lsp.buf.signature_help, opts)
		end

		if client.supports_method("textDocument/inlayHint") then
			opts.desc = "LSP: toggle inlay hints"
			vim.keymap.set("n", "<leader>i", function() Snacks.toggle.inlay_hints() end, opts)
		end

		if client.supports_method("textDocument/hover") then
			opts.desc = "LSP: hover"
			vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts)
		end

		if client.supports_method("textDocument/documentSymbol") then
			opts.desc = "LSP: symbols (document)"
			vim.keymap.set("n", "<leader>s", function() Snacks.picker.lsp_symbols() end, opts)
		end

		if client.supports_method("workspace/symbol") then
			opts.desc = "LSP: symbols (workspace)"
			vim.keymap.set("n", "<leader>S", function() Snacks.picker.lsp_workspace_symbols() end, opts)
		end
	end,
}
