local map = vim.keymap.set

local M = {}

local keys = {
	disable = function()
		map({ "n", "v" }, "s", "<nop>")
	end,
	random = function()
		local opts = { noremap = true }

		opts.desc = "Half page down"
		map("n", "<c-d>", "<c-d>zz", opts)

		opts.desc = "Half page up"
		map("n", "<c-u>", "<c-u>zz", opts)

		opts.desc = "Clear highlights"
		map("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

		opts.desc = "Terminal"
		map({ "n", "t" }, "<c-\\>", require("snacks").terminal.toggle, opts)
		map({ "n", "t" }, "<a-\\>", require("snacks").terminal.open, opts)

		opts.desc = "List buffers"
		map("n", "<c-p>", require("utils").mini.buffers, opts)

		opts.desc = "Commands"
		map("n", "<c-s-p>", require("mini.extra").pickers.commands, opts)

		opts.desc = "Scratch"
		map("n", "<leader>.", require("snacks").scratch.open, opts)

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

		opts.desc = "Paste (no register)"
		map("v", "<leader>P", [["_dP]], opts)

		opts.desc = "Write all"
		map("n", "<leader>W", "<cmd>wall!<cr>", opts)

		opts.desc = "Quit"
		map("n", "<leader>q", "<cmd>q<cr>", opts)

		opts.desc = "Undo tree"
		map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", opts)

		opts.desc = "Visits"
		map("n", "<leader>v", require("mini.extra").pickers.visit_paths, opts)

		opts.desc = "Write"
		map("n", "<leader>w", "<cmd>silent w!<cr>", opts)

		opts.desc = "Quickfix"
		map("n", "<leader>x", "<cmd>copen<cr>", opts)

		opts.desc = "Zoom"
		map("n", "<leader>z", require("snacks").zen.zoom, opts)

		opts.desc = "Zen"
		map("n", "<leader>Z", require("snacks").zen.zen, opts)

		opts.desc = "Explorer"
		map("n", "<leader>e", function()
			if not require("mini.files").close() then
				require("mini.files").open(vim.fn.expand("%:p:h"), true)
			end
		end, opts)

		opts.desc = "Explorer (cwd)"
		map("n", "<leader>E", function()
			require("mini.files").open(vim.uv.cwd(), true)
		end, opts)

		opts.desc = "todo.txt"
		map("n", "<leader>t", function()
			vim.cmd("split " .. vim.env.HOME .. "/Documents/notes/todo.txt")
		end, opts)
	end,
	better_keys = function()
		local opts = { expr = true, noremap = true, silent = true, desc = "Better keys" }

		map("n", "j", [[v:count == 0 ? 'gj' : 'j']], opts)
		map("n", "k", [[v:count == 0 ? 'gk' : 'k']], opts)
		map("n", "N", "'nN'[v:searchforward].'zv'", opts)
		map("o", "N", "'nN'[v:searchforward]", opts)
		map("v", "N", "'nN'[v:searchforward]", opts)
		map("n", "n", "'Nn'[v:searchforward].'zv'", opts)
		map("o", "n", "'Nn'[v:searchforward]", opts)
		map("v", "n", "'Nn'[v:searchforward]", opts)
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
	copilot = function()
		local opts = { noremap = true }

		opts.desc = "Quick chat"
		map("v", "<leader>cc", "<cmd>CopilotChat<cr>", opts)
		map("n", "<leader>cc", function()
			local input = vim.fn.input("Quick Chat: ")

			if input ~= "" then
				require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
			end
		end, opts)

		opts.desc = "Toggle chat"
		map("n", "<leader>ct", "<cmd>CopilotChatToggle<cr>", opts)

		opts.desc = "Stop chat"
		map("n", "<leader>cs", "<cmd>CopilotChatStop<cr>", opts)

		opts.desc = "Reset chat"
		map("n", "<leader>cr", "<cmd>CopilotChatReset<cr>", opts)

		opts.desc = "Explain"
		map({ "n", "v" }, "<leader>ce", "<cmd>CopilotChatExplain<cr>", opts)

		opts.desc = "Fix"
		map({ "n", "v" }, "<leader>cf", "<cmd>CopilotChatFix<cr>", opts)

		opts.desc = "Optimize"
		map({ "n", "v" }, "<leader>co", "<cmd>CopilotChatOptimize<cr>", opts)

		opts.desc = "Generate docs"
		map({ "n", "v" }, "<leader>cd", "<cmd>CopilotChatDocs<cr>", opts)

		opts.desc = "Generate tests"
		map({ "n", "v" }, "<leader>cT", "<cmd>CopilotChatTests<cr>", opts)

		opts.desc = "Review"
		map({ "n", "v" }, "<leader>cR", "<cmd>CopilotChatReview<cr>", opts)
	end,
	git = function()
		local opts = { noremap = true }

		opts.desc = "Add (file)"
		map("n", "<leader>ga", "<cmd>Git add %<cr>", opts)

		opts.desc = "Add (repo)"
		map("n", "<leader>gA", "<cmd>Git add --all<cr>", opts)

		opts.desc = "Blame"
		map("n", "<leader>gb", require("snacks").git.blame_line, opts)

		opts.desc = "Commit"
		map("n", "<leader>gc", "<cmd>Git commit<cr>", opts)

		opts.desc = "Diff"
		map("n", "<leader>gd", "<cmd>Git diff %<cr>", opts)

		opts.desc = "LazyGit"
		map("n", "<leader>gg", require("snacks").lazygit.open, opts)

		opts.desc = "Log (file)"
		map("n", "<leader>gl", require("snacks").lazygit.log_file, opts)

		opts.desc = "Log (repo)"
		map("n", "<leader>gL", require("snacks").lazygit.log, opts)

		opts.desc = "History"
		map({ "n", "v" }, "<leader>gh", require("mini.git").show_at_cursor, opts)

		opts.desc = "Hunks"
		map("n", "<leader>gH", require("mini.extra").pickers.git_hunks, opts)

		opts.desc = "Pull"
		map("n", "<leader>gp", "<cmd>Git pull<cr>", opts)

		opts.desc = "Push"
		map("n", "<leader>gP", "<cmd>Git push<cr>", opts)

		opts.desc = "Open in browser"
		map({ "n", "v" }, "<leader>go", require("snacks").gitbrowse.open, opts)
	end,
	macros = function()
		local opts = { noremap = true, expr = true }

		opts.desc = "Record macro"
		map("n", "Q", "@q", opts)

		opts.desc = "Replace with macro"
		map("v", "Q", ":norm @q<cr>", opts)
	end,
	notes = function()
		local opts = { noremap = true }

		opts.desc = "Search"
		map("n", "<leader>ns", require("dev.notes").search, opts)

		opts.desc = "Live grep"
		map("n", "<leader>n/", require("dev.notes").grep_live, opts)

		opts.desc = "New"
		map("n", "<leader>nn", require("dev.notes").new, opts)
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

		opts.desc = "Smart splits: move cursor"
		map({ "n", "t" }, "<c-h>", require("smart-splits").move_cursor_left, opts)
		map({ "n", "t" }, "<c-j>", require("smart-splits").move_cursor_down, opts)
		map({ "n", "t" }, "<c-k>", require("smart-splits").move_cursor_up, opts)
		map({ "n", "t" }, "<c-l>", require("smart-splits").move_cursor_right, opts)

		opts.desc = "Smart splits: resize panes"
		map({ "n", "t" }, "<a-h>", require("smart-splits").resize_left, opts)
		map({ "n", "t" }, "<a-j>", require("smart-splits").resize_down, opts)
		map({ "n", "t" }, "<a-k>", require("smart-splits").resize_up, opts)
		map({ "n", "t" }, "<a-l>", require("smart-splits").resize_right, opts)

		opts.desc = "Smart splits: swap buffer"
		map("n", "<c-left>", require("smart-splits").swap_buf_left, opts)
		map("n", "<c-down>", require("smart-splits").swap_buf_down, opts)
		map("n", "<c-up>", require("smart-splits").swap_buf_up, opts)
		map("n", "<c-right>", require("smart-splits").swap_buf_right, opts)
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

	opts.desc = "LSP: go to next reference"
	map("n", "]r", function()
		require("snacks").words.jump(vim.v.count1)
	end, opts)

	opts.desc = "LSP: go to previous reference"
	map("n", "[r", function()
		require("snacks").words.jump(-vim.v.count1)
	end, opts)

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
		map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
	end

	if client.supports_method("textDocument/publishDiagnostics") then
		opts.desc = "LSP: diagnostics"
		map("n", "<leader>d", require("mini.extra").pickers.diagnostic, opts)

		opts.desc = "LSP: diagnostics (float)"
		map("n", "<leader>f", vim.diagnostic.open_float, opts)
	end

	if client.supports_method("textDocument/signatureHelp") then
		opts.desc = "LSP: signature help"
		map("n", "<leader>h", vim.lsp.buf.signature_help, opts)
	end

	if client.supports_method("textDocument/inlayHint") then
		opts.desc = "LSP: toggle inlay hints"
		map("n", "<leader>i", require("snacks").toggle.inlay_hints, opts)
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
	map("n", "<localleader>o", require("dap").step_out, opts)

	opts.desc = "DAP: step into"
	map("n", "<localleader>i", require("dap").step_into, opts)

	opts.desc = "DAP: step back"
	map("n", "<f7>", require("dap").step_back, opts)

	opts.desc = "DAP: continue"
	map("n", "<f8>", require("dap").continue, opts)

	opts.desc = "DAP: step over"
	map("n", "<f9>", require("dap").step_over, opts)

	opts.desc = "DAP: pause"
	map("n", "<s-f8>", require("dap").pause, opts)

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
end

M.markdown = function(bufnr)
	local opts = { buffer = bufnr }

	opts.desc = "Markdown: add item below"
	map({ "n", "i" }, "<c-c><c-j>", "<cmd>MDListItemBelow<cr>", opts)

	opts.desc = "Markdown: add item above"
	map({ "n", "i" }, "<c-c><c-k>", "<cmd>MDListItemAbove<cr>", opts)

	opts.desc = "Markdown: toggle checkbox"
	map("n", "<c-cr>", require("utils").toggle_checkbox, opts)

	opts.desc = "Markdown: toggle italic"
	map("v", "<c-i>", require("utils").toggle_emphasis("i"), opts)

	opts.desc = "Markdown: toggle bold"
	map("v", "<c-b>", require("utils").toggle_emphasis("b"), opts)

	opts.desc = "Markdown: preview document"
	map("n", "<leader>p", "<cmd>MarkdownPreviewToggle<cr>", opts)

	opts.desc = "Markdown: paste image"
	map("n", "<leader>P", "<cmd>PasteImage<cr>", opts)
end

M.python = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "Python: test function/method"
	map("n", "<localleader>f", require("dap-python").test_method, opts)

	opts.desc = "Python: test class"
	map("n", "<localleader>c", require("dap-python").test_class, opts)

	opts.desc = "Python: debug selection"
	map("v", "<localleader>s", require("dap-python").debug_selection, opts)
end

M.go = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "Go: debug test"
	map("n", "<localleader>t", require("dap-go").debug_test, opts)

	opts.desc = "Go: debug last test"
	map("n", "<localleader>l", require("dap-go").debug_last_test, opts)
end

M.lua = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "Lua: source file"
	map("n", "<localleader>%", "<cmd>source %<cr>", opts)

	opts.desc = "Lua: run line"
	map("n", "<localleader>.", ":.lua<cr>", opts)

	opts.desc = "Lua: run"
	map("v", "<localleader>.", ":lua<cr>", opts)
end

M.mini = {
	files = function(event)
		local opts = { noremap = true, buffer = event.data.buf_id }

		map("n", ".", require("utils").mini.files.toggle_dotfiles, opts)
		map("n", "<c-;>", require("utils").mini.files.set_cwd, opts)
		map("n", "<c-->", require("utils").mini.files.map_split("horizontal", true), opts)
		map("n", "<c-\\>", require("utils").mini.files.map_split("vertical", true), opts)
	end,
}

M.rest = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "Rest: run"
	map("n", "<leader>r", "<cmd>Rest run<cr>", opts)
end

M.setup = function()
	for _, fn in pairs(keys) do
		fn()
	end
end

return M
