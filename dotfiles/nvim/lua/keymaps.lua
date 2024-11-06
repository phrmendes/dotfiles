local luasnip = require("luasnip")
local map = vim.keymap.set

local M = {}

local keys = {
	disable = function()
		map({ "n", "x" }, "s", "<nop>")
	end,
	random = function()
		local opts = { noremap = true }

		opts.desc = "Half page down"
		map("n", "<c-d>", "<c-d>zz", opts)

		opts.desc = "Half page up"
		map("n", "<c-u>", "<c-u>zz", opts)

		opts.desc = "Clear highlights"
		map("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

		opts.desc = "Yazi"
		map("n", "-", "<cmd>Yazi toggle<cr>", opts)

		opts.desc = "Split (H)"
		map("n", "<leader>-", "<cmd>split<cr>", opts)

		opts.desc = "Split (V)"
		map("n", "<leader>\\", "<cmd>vsplit<cr>", opts)

		opts.desc = "Live grep"
		map("n", "<leader>/", require("mini.pick").builtin.grep_live, opts)

		opts.desc = "Resize and make windows equal"
		map("n", "<leader>=", "<c-w>=", opts)

		opts.desc = "Help"
		map("n", "<leader>?", require("mini.pick").builtin.help, opts)

		opts.desc = "Find"
		map("n", "<leader><leader>", require("mini.pick").builtin.files, opts)

		opts.desc = "Keymaps"
		map("n", "<leader>K", require("mini.extra").pickers.keymaps, opts)

		opts.desc = "Write all"
		map("n", "<leader>W", "<cmd>wall!<cr>", opts)

		opts.desc = "Undo tree"
		map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", opts)

		opts.desc = "Visits"
		map("n", "<leader>v", require("mini.extra").pickers.visit_paths, opts)

		opts.desc = "Quit"
		map("n", "<leader>q", "<cmd>q<cr>", opts)

		opts.desc = "Write"
		map("n", "<leader>w", "<cmd>w!<cr>", opts)

		opts.desc = "Quickfix"
		map("n", "<leader>x", "<cmd>copen<cr>", opts)

		opts.desc = "Zoom"
		map("n", "<leader>z", require("mini.misc").zoom, opts)

		opts.desc = "List buffers"
		map("n", "<leader>l", function()
			require("mini.pick").builtin.buffers(nil, {
				mappings = require("utils").mini.buffers.delete(),
			})
		end, opts)
	end,
	better_keys = function()
		local opts = { expr = true, noremap = true, silent = true, desc = "Better keys" }

		map("n", "j", [[v:count == 0 ? 'gj' : 'j']], opts)
		map("n", "k", [[v:count == 0 ? 'gk' : 'k']], opts)
		map("n", "N", "'nN'[v:searchforward].'zv'", opts)
		map("o", "N", "'nN'[v:searchforward]", opts)
		map("x", "N", "'nN'[v:searchforward]", opts)
		map("n", "n", "'Nn'[v:searchforward].'zv'", opts)
		map("o", "n", "'Nn'[v:searchforward]", opts)
		map("x", "n", "'Nn'[v:searchforward]", opts)
	end,
	buffers = function()
		local opts = { noremap = true }

		opts.desc = "First"
		map("n", "<leader>bg", "<cmd>bfirst<cr>", opts)

		opts.desc = "Last"
		map("n", "<leader>bG", "<cmd>blast<cr>", opts)

		opts.desc = "Keep this"
		map("n", "<leader>bk", "<cmd>wall!<bar>%bdelete<bar>edit#<bar>bdelete#<cr>", opts)

		opts.desc = "Delete"
		map("n", "<leader>bd", require("mini.bufremove").delete, opts)

		opts.desc = "Wipeout"
		map("n", "<leader>bw", require("mini.bufremove").wipeout, opts)
	end,
	git = function()
		local opts = { noremap = true }

		opts.desc = "Commit"
		map("n", "<leader>g<space>", "<cmd>Git commit<cr>", opts)

		opts.desc = "Add (file)"
		map("n", "<leader>ga", "<cmd>Git add %<cr>", opts)

		opts.desc = "Add (repo)"
		map("n", "<leader>gA", "<cmd>Git add .<cr>", opts)

		opts.desc = "Commits (file)"
		map("n", "<leader>gc", "<cmd>LazyGitFilterCurrentFile<cr>", opts)

		opts.desc = "Commits (repo)"
		map("n", "<leader>gC", "<cmd>LazyGitFilter<cr>", opts)

		opts.desc = "Diff"
		map("n", "<leader>gd", "<cmd>Git diff %<cr>", opts)

		opts.desc = "LazyGit"
		map("n", "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", opts)

		opts.desc = "History"
		map({ "n", "x" }, "<leader>gh", require("mini.git").show_at_cursor, opts)

		opts.desc = "Hunks"
		map("n", "<leader>gH", require("mini.extra").pickers.git_hunks, opts)

		opts.desc = "Pull"
		map("n", "<leader>gp", "<cmd>Git pull<cr>", opts)

		opts.desc = "Push"
		map("n", "<leader>gP", "<cmd>Git push<cr>", opts)
	end,
	luasnip = function()
		local opts = { noremap = true, silent = true }

		opts.desc = "Next snippet choice"
		map({ "i", "s" }, "<c-j>", function()
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			end
		end, opts)

		opts.desc = "Previous snippet choice"
		map({ "i", "s" }, "<c-k>", function()
			if luasnip.choice_active() then
				luasnip.change_choice(-1)
			end
		end, opts)
	end,
	macros = function()
		local opts = { noremap = true, expr = true }

		opts.desc = "Record macro"
		map("n", "Q", "@q", opts)

		opts.desc = "Replace with macro"
		map("x", "Q", "<cmd>norm @q<cr>", opts)
	end,
	neogen = function()
		local opts = { noremap = true }

		opts.desc = "Generate documentation"
		map("n", "<leader>G", require("neogen").generate, opts)
	end,
	obsidian = function()
		local opts = { noremap = true }

		opts.desc = "Backlinks"
		map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", opts)

		opts.desc = "New note"
		map("n", "<leader>on", "<cmd>ObsidianNew<cr>", opts)

		opts.desc = "Extract to new note"
		map("x", "<leader>oe", "<cmd>ObsidianExtractNote<cr>", opts)

		opts.desc = "Add link"
		map("x", "<leader>oa", "<cmd>ObsidianLink<cr>", opts)

		opts.desc = "Add link to new file"
		map("x", "<leader>on", "<cmd>ObsidianLinkNew<cr>", opts)

		opts.desc = "Search"
		map("n", "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", opts)

		opts.desc = "Paste image"
		map("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", opts)

		opts.desc = "Rename"
		map("n", "<leader>or", "<cmd>ObsidianRename<cr>", opts)

		opts.desc = "Live grep"
		map("n", "<leader>og", "<cmd>ObsidianSearch<cr>", opts)

		opts.desc = "Tags"
		map("n", "<leader>ot", "<cmd>ObsidianTags<cr>", opts)
	end,
	slime = function()
		local opts = { noremap = true }

		opts.desc = "Slime: send to terminal"
		map("n", "<c-c><c-c>", "<Plug>SlimeParagraphSend", opts)
		map("v", "<c-c><c-c>", "<Plug>SlimeRegionSend", opts)

		opts.desc = "Slime: settings"
		map("n", "<c-c><c-s>", "<Plug>SlimeConfig", opts)
	end,
	smart_splits = function()
		local opts = { desc = "Smart splits" }

		map("n", "<c-h>", require("smart-splits").move_cursor_left, opts)
		map("n", "<c-j>", require("smart-splits").move_cursor_down, opts)
		map("n", "<c-k>", require("smart-splits").move_cursor_up, opts)
		map("n", "<c-l>", require("smart-splits").move_cursor_right, opts)
		map("n", "<c-left>", require("smart-splits").resize_left, opts)
		map("n", "<c-down>", require("smart-splits").resize_down, opts)
		map("n", "<c-up>", require("smart-splits").resize_up, opts)
		map("n", "<c-right>", require("smart-splits").resize_right, opts)
		map("n", "<c-s-left>", require("smart-splits").swap_buf_left, opts)
		map("n", "<c-s-down>", require("smart-splits").swap_buf_down, opts)
		map("n", "<c-s-up>", require("smart-splits").swap_buf_up, opts)
		map("n", "<c-s-right>", require("smart-splits").swap_buf_right, opts)
	end,
	tabs = function()
		local opts = { noremap = true }

		opts.desc = "Previous"
		map("n", "[<tab>", "<cmd>tabprevious<cr>", opts)

		opts.desc = "Next"
		map("n", "]<tab>", "<cmd>tabnext<cr>", opts)

		opts.desc = "Last"
		map("n", "<leader><tab>G", "<cmd>tablast<cr>", opts)

		opts.desc = "Close"
		map("n", "<leader><tab>q", "<cmd>tabclose<cr>", opts)

		opts.desc = "First"
		map("n", "<leader><tab>g", "<cmd>tabfirst<cr>", opts)

		opts.desc = "Keep"
		map("n", "<leader><tab>k", "<cmd>tabonly<cr>", opts)

		opts.desc = "New"
		map("n", "<leader><tab>n", "<cmd>tabnew<cr>", opts)

		opts.desc = "Edit"
		map("n", "<leader><tab>e", "<cmd>tabedit %<cr>", opts)
	end,
}

M.terminal = function(event)
	local opts = { buffer = event.buf }

	map("t", "<c-c>", "<c-\\><c-n>", opts)
	map("t", "<c-w>", "<c-\\><c-n><c-w>", opts)
	map("t", "<c-h>", "<cmd>wincmd h<cr>", opts)
	map("t", "<c-j>", "<cmd>wincmd j<cr>", opts)
	map("t", "<c-k>", "<cmd>wincmd k<cr>", opts)
	map("t", "<c-l>", "<cmd>wincmd l<cr>", opts)
end

M.lsp = function(client, bufnr)
	local opts = { noremap = true, buffer = bufnr }

	if client.supports_method("textDocument/rename") then
		opts.desc = "LSP: rename symbol"
		map("n", "<f2>", vim.lsp.buf.rename, opts)
	end

	if client.supports_method("textDocument/definition") then
		opts.desc = "LSP: go to definition"
		map("n", "gd", function()
			require("mini.extra").pickers.lsp({ scope = "definition" })
		end, opts)
	end

	if client.supports_method("textDocument/declaration") then
		opts.desc = "LSP: go to declaration"
		map("n", "gD", function()
			require("mini.extra").pickers.lsp({ scope = "declaration" })
		end, opts)
	end

	if client.supports_method("textDocument/implementation") then
		opts.desc = "LSP: go to implementations"
		map("n", "gi", function()
			require("mini.extra").pickers.lsp({ scope = "implementation" })
		end, opts)
	end

	if client.supports_method("textDocument/references") then
		opts.desc = "LSP: go to references"
		map("n", "gr", function()
			require("mini.extra").pickers.lsp({ scope = "references" })
		end, opts)
	end

	if client.supports_method("textDocument/typeDefinition") then
		opts.desc = "LSP: go to type definition"
		map("n", "gt", function()
			require("mini.extra").pickers.lsp({ scope = "type_definition" })
		end, opts)
	end

	if client.supports_method("textDocument/codeAction") then
		opts.desc = "LSP: code actions"
		map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, opts)
	end

	if client.supports_method("textDocument/publishDiagnostics") then
		opts.desc = "LSP: diagnostics"
		map("n", "<leader>d", require("mini.extra").pickers.diagnostic, opts)
		map("n", "<leader>f", vim.diagnostic.open_float)
	end

	if client.supports_method("textDocument/signatureHelp") then
		opts.desc = "LSP: signature help"
		map("n", "<leader>h", vim.lsp.buf.signature_help, opts)
	end

	if client.supports_method("textDocument/hover") then
		opts.desc = "LSP: hover"
		map("n", "<leader>k", vim.lsp.buf.hover, opts)
	end

	if client.supports_method("textDocument/documentSymbol") then
		opts.desc = "LSP: symbols (document)"
		map("n", "<leader>s", function()
			require("mini.extra").pickers.lsp({ scope = "document_symbol" })
		end, opts)
	end

	if client.supports_method("workspace/symbol") then
		opts.desc = "LSP: symbols (workspace)"
		map("n", "<leader>S", function()
			require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
		end, opts)
	end
end

M.dap = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "DAP: step out"
	map("n", "<f3>", require("dap").step_out, opts)

	opts.desc = "DAP: step into"
	map("n", "<f4>", require("dap").step_into, opts)

	opts.desc = "DAP: step back"
	map("n", "<f5>", require("dap").step_back, opts)

	opts.desc = "DAP: continue"
	map("n", "<f6>", require("dap").continue, opts)

	opts.desc = "DAP: step over"
	map("n", "<f7>", require("dap").step_over, opts)

	opts.desc = "DAP: pause"
	map("n", "<s-f6>", require("dap").pause, opts)

	opts.desc = "DAP: terminate"
	map("n", "<del>", require("dap").terminate, opts)

	opts.desc = "DAP: breakpoint"
	map("n", "<localleader>b", require("dap").toggle_breakpoint, opts)

	opts.desc = "DAP: debug last"
	map("n", "<localleader><bs>", require("dap").run_last, opts)

	opts.desc = "DAP: clear all breakpoints"
	map("n", "<localleader><del>", require("dap").clear_breakpoints, opts)

	opts.desc = "DAP: show hover"
	map("n", "<localleader>k", require("dap.ui.widgets").hover, opts)

	opts.desc = "DAP: toggle UI"
	map("n", "<localleader>u", require("dapui").toggle, opts)

	opts.desc = "DAP: eval"
	map("n", "<localleader>?", function()
		require("dapui").eval(nil, { enter = true })
	end, opts)

	opts.desc = "DAP: conditional breakpoint"
	map("n", "<localleader>B", function()
		require("dap").set_breakpoint(vim.fn.input("Condition: "))
	end, opts)
end

M.markdown = function(event)
	local opts = { noremap = true, buffer = event.buf }

	opts.desc = "Preview equation"
	map("n", "<localleader>e", require("nabla").popup, opts)

	opts.desc = "Add item below"
	map({ "n", "i" }, "<c-cr>", "<cmd>MDListItemBelow<cr>", opts)

	opts.desc = "Add item above"
	map({ "n", "i" }, "<s-cr>", "<cmd>MDListItemAbove<cr>", opts)

	opts.desc = "Preview document"
	map("n", "<leader>p", "<cmd>MarkdownPreviewToggle<cr>", opts)
end

M.lua = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "DAP: continue"
	map("n", "<f6>", require("osv").run_this, opts)
end

M.python = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "Python: debug function/method"
	map("n", "<localleader>f", require("dap-python").test_method, opts)

	opts.desc = "Python: debug class"
	map("n", "<localleader>c", require("dap-python").test_class, opts)

	opts.desc = "Python: debug selection"
	map("x", "<localleader>s", require("dap-python").debug_selection, opts)
end

M.go = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "Go: debug test"
	map("n", "<localleader>t", require("dap-go").debug_test, opts)

	opts.desc = "Go: debug last test"
	map("n", "<localleader>l", require("dap-go").debug_last_test, opts)
end

M.setup = function()
	for _, fn in pairs(keys) do
		fn()
	end
end

return M
