local luasnip = require("luasnip")
local map = vim.keymap.set
local utils = require("utils")

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

		opts.desc = "Escape terminal mode"
		map("t", "<c-c><c-c>", "<c-\\><c-n>", opts)

		opts.desc = "Split (H)"
		map("n", "<leader>-", "<cmd>split<cr>", opts)

		opts.desc = "Split (V)"
		map("n", "<leader>\\", "<cmd>vsplit<cr>", opts)

		opts.desc = "Live grep"
		map("n", "<leader>/", require("telescope.builtin").live_grep, opts)

		opts.desc = "Resize and make windows equal"
		map("n", "<leader>=", "<c-w>=", opts)

		opts.desc = "Help"
		map("n", "<leader>?", require("telescope.builtin").help_tags, opts)

		opts.desc = "Open"
		map("n", "<leader><leader>", require("telescope").extensions.smart_open.smart_open, opts)

		opts.desc = "Write all"
		map("n", "<leader>W", "<cmd>wall!<cr>", opts)

		opts.desc = "Find in buffer"
		map("n", "<leader>f", require("telescope.builtin").current_buffer_fuzzy_find, opts)

		opts.desc = "Undo tree"
		map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", opts)

		opts.desc = "Quit"
		map("n", "<leader>q", "<cmd>q<cr>", opts)

		opts.desc = "Write"
		map("n", "<leader>w", "<cmd>w!<cr>", opts)

		opts.desc = "Quickfix"
		map("n", "<leader>x", "<cmd>copen<cr>", opts)

		opts.desc = "Zoom"
		map("n", "<leader>z", require("mini.misc").zoom, opts)
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
	dial = function()
		local opts = { noremap = true, silent = true, desc = "Dial" }

		map("n", "<c-a>", function()
			require("dial.map").manipulate("increment", "normal")
		end, opts)

		map("n", "<c-x>", function()
			require("dial.map").manipulate("decrement", "normal")
		end, opts)

		map("v", "<c-a>", function()
			require("dial.map").manipulate("increment", "visual")
		end, opts)

		map("v", "<c-x>", function()
			require("dial.map").manipulate("decrement", "visual")
		end, opts)
	end,
	explorer = function()
		local opts = { noremap = true }

		opts.desc = "Explorer"
		map("n", "<leader>e", "<cmd>Yazi<cr>", opts)

		opts.desc = "Explorer (cwd)"
		map("n", "<leader>E", "<cmd>Yazi cwd<cr>", opts)
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
		local opts = { noremap = true, desc = "Smart splits" }

		map({ "n", "t" }, "<a-h>", require("smart-splits").resize_left, opts)
		map({ "n", "t" }, "<a-j>", require("smart-splits").resize_down, opts)
		map({ "n", "t" }, "<a-k>", require("smart-splits").resize_up, opts)
		map({ "n", "t" }, "<a-l>", require("smart-splits").resize_right, opts)
		map({ "n", "t" }, "<c-h>", require("smart-splits").move_cursor_left, opts)
		map({ "n", "t" }, "<c-j>", require("smart-splits").move_cursor_down, opts)
		map({ "n", "t" }, "<c-k>", require("smart-splits").move_cursor_up, opts)
		map({ "n", "t" }, "<c-l>", require("smart-splits").move_cursor_right, opts)
		map({ "n", "t" }, "<c-down>", require("smart-splits").swap_buf_down, opts)
		map({ "n", "t" }, "<c-left>", require("smart-splits").swap_buf_left, opts)
		map({ "n", "t" }, "<c-right>", require("smart-splits").swap_buf_right, opts)
		map({ "n", "t" }, "<c-up>", require("smart-splits").swap_buf_up, opts)
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

M.lsp = function(client, bufnr)
	local opts = { noremap = true, buffer = bufnr }

	if client.supports_method("textDocument/rename") then
		opts.desc = "LSP: rename symbol"
		map("n", "<f2>", vim.lsp.buf.rename, opts)
	end

	if client.supports_method("textDocument/definition") then
		opts.desc = "LSP: go to definition"
		map("n", "gd", require("telescope.builtin").lsp_definitions, opts)
	end

	if client.supports_method("textDocument/declaration") then
		opts.desc = "LSP: go to declaration"
		map("n", "gD", vim.lsp.buf.declaration, opts)
	end

	if client.supports_method("textDocument/implementation") then
		opts.desc = "LSP: go to implementations"
		map("n", "gi", require("telescope.builtin").lsp_implementations, opts)
	end

	if client.supports_method("textDocument/references") then
		opts.desc = "LSP: go to references"
		map("n", "gr", require("telescope.builtin").lsp_references, opts)
	end

	if client.supports_method("textDocument/typeDefinition") then
		opts.desc = "LSP: go to type definition"
		map("n", "gt", require("telescope.builtin").lsp_type_definitions, opts)
	end

	if client.supports_method("textDocument/codeAction") then
		opts.desc = "LSP: code actions"
		map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, opts)
	end

	if client.supports_method("textDocument/publishDiagnostics") then
		opts.desc = "LSP: diagnostics"
		map("n", "<leader>d", require("telescope.builtin").diagnostics, opts)
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
		map("n", "<leader>s", require("telescope.builtin").lsp_document_symbols, opts)
	end

	if client.supports_method("workspace/symbol") then
		opts.desc = "LSP: symbols (workspace)"
		map("n", "<leader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)
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

M.refactoring = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "Refactoring"
	map({ "n", "x" }, "<leader>r", require("refactoring").select_refactor, opts)

	opts.desc = "Print variable"
	map("n", "<leader>p", require("refactoring").debug.print_var, opts)

	opts.desc = "Clean print statements"
	map("n", "<leader>c", require("refactoring").debug.cleanup, opts)
end

M.tests = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "Neotest: run nearest test"
	map("n", "<localleader>t", require("neotest").run.run, opts)

	opts.desc = "Neotest: run current file"
	map("n", "<localleader>T", function()
		require("neotest").run.run(vim.fn.expand("%"))
	end, opts)

	opts.desc = "Neotest: debug nearest test"
	map("n", "<localleader>d", function()
		require("neotest").run.run({ strategy = "dap" })
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

	opts.desc = "Zotcite: citation info"
	map("n", "<leader>i", "<Plug>ZCitationInfo", opts)

	opts.desc = "Zotcite: citation info (complete)"
	map("n", "<leader>I", "<Plug>ZCitationCompleteInfo", opts)

	opts.desc = "Zotcite: open attachment"
	map("n", "<leader>O", "<Plug>ZOpenAttachment", opts)

	opts.desc = "Zotcite: view document"
	map("n", "<leader>v", "<Plug>ZViewDocument", opts)

	opts.desc = "Zotcite: YAML reference"
	map("n", "<leader>y", "<Plug>ZCitationYamlRef", opts)

	opts.desc = "Zotcite: extract abstract"
	map("n", "<Leader>X", "<Plug>ZExtractAbstract", opts)
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

M.setup = function()
	for _, fn in pairs(keys) do
		fn()
	end
end

return M
