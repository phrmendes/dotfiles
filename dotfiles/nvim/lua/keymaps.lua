return {
	default = function()
		-- unmap default keys
		vim.keymap.del("n", "gra")
		vim.keymap.del("n", "gri")
		vim.keymap.del("n", "grn")
		vim.keymap.del("n", "grr")

		-- random
		vim.keymap.set({ "n", "x" }, "s", "<nop>")
		vim.keymap.set("n", "<c-d>", "<c-d>zz", { noremap = true, desc = "Half page down" })
		vim.keymap.set("n", "<c-u>", "<c-u>zz", { noremap = true, desc = "Half page up" })
		vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { noremap = true, desc = "Clear highlights" })

		-- better default keys
		vim.keymap.set("n", "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, noremap = true, silent = true })
		vim.keymap.set("n", "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, noremap = true, silent = true })
		vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, noremap = true, silent = true })
		vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, noremap = true, silent = true })
		vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, noremap = true, silent = true })
		vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, noremap = true, silent = true })
		vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, noremap = true, silent = true })
		vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, noremap = true, silent = true })

		-- leader keys
		vim.keymap.set("n", "<leader>-", "<cmd>split<cr>", { noremap = true, desc = "Split (H)" })
		vim.keymap.set("n", "<leader>=", "<c-w>=", { noremap = true, desc = "Resize and make windows equal" })
		vim.keymap.set("n", "<leader>\\", "<cmd>vsplit<cr>", { noremap = true, desc = "Split (V)" })
		vim.keymap.set("n", "<leader>W", "<cmd>wall!<cr>", { noremap = true, desc = "Write all" })
		vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { noremap = true, desc = "Quit" })
		vim.keymap.set("n", "<leader>w", "<cmd>silent w!<cr>", { noremap = true, desc = "Write" })
		vim.keymap.set("n", "<leader>x", "<cmd>copen<cr>", { noremap = true, desc = "Quickfix" })

		-- buffer keys
		vim.keymap.set("n", "<leader>bG", "<cmd>blast<cr>", { noremap = true, desc = "Last" })
		vim.keymap.set("n", "<leader>bg", "<cmd>bfirst<cr>", { noremap = true, desc = "First" })
		vim.keymap.set("n", "<leader>bk", "<cmd>wall!<bar>%bdelete<bar>edit#<bar>bdelete#<cr>", {
			noremap = true,
			desc = "Keep this",
		})

		-- tab keys
		vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>", { noremap = true, desc = "Previous" })
		vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>", { noremap = true, desc = "Next" })
		vim.keymap.set("n", "<leader><tab>G", "<cmd>tablast<cr>", { noremap = true, desc = "Last" })
		vim.keymap.set("n", "<leader><tab>q", "<cmd>tabclose<cr>", { noremap = true, desc = "Close" })
		vim.keymap.set("n", "<leader><tab>g", "<cmd>tabfirst<cr>", { noremap = true, desc = "First" })
		vim.keymap.set("n", "<leader><tab>k", "<cmd>tabonly<cr>", { noremap = true, desc = "Keep" })
		vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>", { noremap = true, desc = "New" })
		vim.keymap.set("n", "<leader><tab>e", "<cmd>tabedit %<cr>", { noremap = true, desc = "Edit" })
	end,
	lsp = function(client, bufnr)
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
			vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, opts)
		end

		if client:supports_method("textDocument/declaration", bufnr) then
			opts.desc = "LSP: go to declaration"
			vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, opts)
		end

		if client:supports_method("textDocument/implementation", bufnr) then
			opts.desc = "LSP: go to implementations"
			vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, opts)
		end

		if client:supports_method("textDocument/references", bufnr) then
			opts.desc = "LSP: go to references"
			vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, opts)
		end

		if client:supports_method("textDocument/typeDefinition", bufnr) then
			opts.desc = "LSP: go to type definition"
			vim.keymap.set("n", "gt", function() Snacks.picker.lsp_type_definitions() end, opts)
		end

		if client:supports_method("textDocument/codeAction", bufnr) then
			opts.desc = "LSP: code actions"
			vim.keymap.set({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, opts)
		end

		if client:supports_method("textDocument/publishDiagnostics", bufnr) then
			opts.desc = "LSP: diagnostics"
			vim.keymap.set("n", "<leader>d", function() Snacks.picker.diagnostics_buffer() end, opts)

			opts.desc = "LSP: workspace diagnostics"
			vim.keymap.set("n", "<leader>D", function() Snacks.picker.diagnostics() end, opts)

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
			vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts)
		end

		if client:supports_method("textDocument/documentSymbol", bufnr) then
			opts.desc = "LSP: symbols (document)"
			vim.keymap.set("n", "<leader>s", function() Snacks.picker.lsp_symbols() end, opts)
		end

		if client:supports_method("workspace/symbol", bufnr) then
			opts.desc = "LSP: symbols (workspace)"
			vim.keymap.set("n", "<leader>S", function() Snacks.picker.lsp_workspace_symbols() end, opts)
		end
	end,
}
