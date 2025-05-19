local map = vim.keymap.set
local del_map = vim.keymap.del

return {
	default = function()
		-- unmap default keys
		del_map("n", "gra")
		del_map("n", "gri")
		del_map("n", "grn")
		del_map("n", "grr")

		-- random
		map({ "n", "x" }, "s", "<nop>")
		map("n", "<c-d>", "<c-d>zz", { noremap = true, desc = "Half page down" })
		map("n", "<c-u>", "<c-u>zz", { noremap = true, desc = "Half page up" })

		-- better default keys
		map("n", "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, noremap = true, silent = true })
		map("n", "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, noremap = true, silent = true })
		map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, noremap = true, silent = true })
		map("o", "N", "'nN'[v:searchforward]", { expr = true, noremap = true, silent = true })
		map("x", "N", "'nN'[v:searchforward]", { expr = true, noremap = true, silent = true })
		map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, noremap = true, silent = true })
		map("o", "n", "'Nn'[v:searchforward]", { expr = true, noremap = true, silent = true })
		map("x", "n", "'Nn'[v:searchforward]", { expr = true, noremap = true, silent = true })

		-- leader keys
		map("n", "<leader>-", "<cmd>split<cr>", { noremap = true, desc = "Split (H)" })
		map("n", "<leader>=", "<c-w>=", { noremap = true, desc = "Resize and make windows equal" })
		map("n", "<leader>\\", "<cmd>vsplit<cr>", { noremap = true, desc = "Split (V)" })
		map("n", "<leader>W", "<cmd>wall!<cr>", { noremap = true, desc = "Write all" })
		map("n", "<leader>q", "<cmd>q<cr>", { noremap = true, desc = "Quit" })
		map("n", "<leader>w", "<cmd>silent w!<cr>", { noremap = true, desc = "Write" })
		map("n", "<leader>x", "<cmd>copen<cr>", { noremap = true, desc = "Quickfix" })

		-- buffer keys
		map("n", "<leader>bG", "<cmd>blast<cr>", { noremap = true, desc = "Last" })
		map("n", "<leader>bg", "<cmd>bfirst<cr>", { noremap = true, desc = "First" })
		map("n", "<leader>bk", "<cmd>wall!<bar>%bdelete<bar>edit#<bar>bdelete#<cr>", { noremap = true, desc = "Keep this" })

		-- tab keys
		map("n", "[<tab>", "<cmd>tabprevious<cr>", { noremap = true, desc = "Previous" })
		map("n", "]<tab>", "<cmd>tabnext<cr>", { noremap = true, desc = "Next" })
		map("n", "<leader><tab>G", "<cmd>tablast<cr>", { noremap = true, desc = "Last" })
		map("n", "<leader><tab>q", "<cmd>tabclose<cr>", { noremap = true, desc = "Close" })
		map("n", "<leader><tab>g", "<cmd>tabfirst<cr>", { noremap = true, desc = "First" })
		map("n", "<leader><tab>k", "<cmd>tabonly<cr>", { noremap = true, desc = "Keep" })
		map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { noremap = true, desc = "New" })
		map("n", "<leader><tab>e", "<cmd>tabedit %<cr>", { noremap = true, desc = "Edit" })
	end,
	lsp = function(client, bufnr)
		local opts = { noremap = true, buffer = bufnr }

		opts.desc = "LSP: go to next reference"
		map("n", "]]", function() Snacks.words.jump(vim.v.count1) end, opts)

		opts.desc = "LSP: go to previous reference"
		map("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, opts)

		if client:supports_method("textDocument/rename", bufnr) then
			opts.desc = "LSP: rename symbol"
			map("n", "<f2>", vim.lsp.buf.rename, opts)
		end

		if client:supports_method("textDocument/definition", bufnr) then
			opts.desc = "LSP: go to definition"
			map("n", "gd", function() require("mini.extra").pickers.lsp({ scope = "definition" }) end, opts)
		end

		if client:supports_method("textDocument/declaration", bufnr) then
			opts.desc = "LSP: go to declaration"
			map("n", "gD", function() require("mini.extra").pickers.lsp({ scope = "declaration" }) end, opts)
		end

		if client:supports_method("textDocument/implementation", bufnr) then
			opts.desc = "LSP: go to implementations"
			map("n", "gi", function() require("mini.extra").pickers.lsp({ scope = "implementation" }) end, opts)
		end

		if client:supports_method("textDocument/references", bufnr) then
			opts.desc = "LSP: go to references"
			map("n", "gr", function() require("mini.extra").pickers.lsp({ scope = "references" }) end, opts)
		end

		if client:supports_method("textDocument/typeDefinition", bufnr) then
			opts.desc = "LSP: go to type definition"
			map("n", "gt", function() require("mini.extra").pickers.lsp({ scope = "type_definition" }) end, opts)
		end

		if client:supports_method("textDocument/codeAction", bufnr) then
			opts.desc = "LSP: code actions"
			map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, opts)
		end

		if client:supports_method("textDocument/publishDiagnostics", bufnr) then
			opts.desc = "LSP: diagnostics"
			map("n", "<leader>d", function() require("mini.extra").pickers.diagnostic({ scope = "current" }) end, opts)

			opts.desc = "LSP: workspace diagnostics"
			map("n", "<leader>D", function() require("mini.extra").pickers.diagnostic() end, opts)

			opts.desc = "LSP: diagnostics (float)"
			map("n", "<leader>f", vim.diagnostic.open_float, opts)
		end

		if client:supports_method("textDocument/signatureHelp", bufnr) then
			opts.desc = "LSP: signature help"
			map("n", "<leader>h", vim.lsp.buf.signature_help, opts)
		end

		if client:supports_method("textDocument/inlayHint", bufnr) then
			opts.desc = "LSP: toggle inlay hints"
			map("n", "<leader>i", function() Snacks.toggle.inlay_hints() end, opts)
		end

		if client:supports_method("textDocument/hover", bufnr) then
			opts.desc = "LSP: hover"
			map("n", "K", vim.lsp.buf.hover, opts)
		end

		if client:supports_method("textDocument/documentSymbol", bufnr) then
			opts.desc = "LSP: symbols (document)"
			map("n", "<leader>s", function() require("mini.extra").pickers.lsp({ scope = "document_symbol" }) end, opts)
		end

		if client:supports_method("workspace/symbol", bufnr) then
			opts.desc = "LSP: symbols (workspace)"
			map("n", "<leader>S", function() require("mini.extra").pickers.lsp({ scope = "workspace_symbol" }) end, opts)
		end
	end,
}
