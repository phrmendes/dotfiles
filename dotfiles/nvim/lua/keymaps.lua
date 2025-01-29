local M = {}

local keys = {
	disable = function()
		vim.keymap.set({ "n", "v" }, "s", "<nop>")
	end,
	random = function()
		local opts = { noremap = true }

		opts.desc = "Half page down"
		vim.keymap.set("n", "<c-d>", "<c-d>zz", opts)

		opts.desc = "Half page up"
		vim.keymap.set("n", "<c-u>", "<c-u>zz", opts)

		opts.desc = "Clear highlights"
		vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

		opts.desc = "Terminal"
		vim.keymap.set({ "n", "t" }, "<c-\\>", require("snacks").terminal.toggle, opts)
		vim.keymap.set({ "n", "t" }, "<a-\\>", require("snacks").terminal.open, opts)

		opts.desc = "List buffers"
		vim.keymap.set("n", "<c-p>", require("utils").mini.buffers, opts)

		opts.desc = "Split (H)"
		vim.keymap.set("n", "<leader>-", "<cmd>split<cr>", opts)

		opts.desc = "Split (V)"
		vim.keymap.set("n", "<leader>\\", "<cmd>vsplit<cr>", opts)

		opts.desc = "Live grep"
		vim.keymap.set("n", "<leader>/", require("mini.pick").builtin.grep_live, opts)

		opts.desc = "Resize and make windows equal"
		vim.keymap.set("n", "<leader>=", "<c-w>=", opts)

		opts.desc = "Help"
		vim.keymap.set("n", "<leader>?", require("mini.pick").builtin.help, opts)

		opts.desc = "Find"
		vim.keymap.set("n", "<leader><leader>", require("mini.pick").builtin.files, opts)

		opts.desc = "Keymaps"
		vim.keymap.set("n", "<leader>K", require("mini.extra").pickers.keymaps, opts)

		opts.desc = "Write all"
		vim.keymap.set("n", "<leader>W", "<cmd>wall!<cr>", opts)

		opts.desc = "Quit"
		vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", opts)

		opts.desc = "Undo tree"
		vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", opts)

		opts.desc = "Visits"
		vim.keymap.set("n", "<leader>v", require("mini.extra").pickers.visit_paths, opts)

		opts.desc = "Write"
		vim.keymap.set("n", "<leader>w", "<cmd>silent w!<cr>", opts)

		opts.desc = "Quickfix"
		vim.keymap.set("n", "<leader>x", "<cmd>copen<cr>", opts)

		opts.desc = "Zoom"
		vim.keymap.set("n", "<leader>z", require("snacks").zen.zoom, opts)

		opts.desc = "Zen"
		vim.keymap.set("n", "<leader>Z", require("snacks").zen.zen, opts)

		opts.desc = "Explorer"
		vim.keymap.set("n", "<leader>e", function()
			if not require("mini.files").close() then
				require("mini.files").open(vim.fn.expand("%:p:h"), true)
			end
		end, opts)

		opts.desc = "Explorer (cwd)"
		vim.keymap.set("n", "<leader>E", function()
			require("mini.files").open(vim.uv.cwd(), true)
		end, opts)
	end,
	better_keys = function()
		local opts = { expr = true, noremap = true, silent = true, desc = "Better keys" }

		vim.keymap.set("n", "j", [[v:count == 0 ? 'gj' : 'j']], opts)
		vim.keymap.set("n", "k", [[v:count == 0 ? 'gk' : 'k']], opts)
		vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", opts)
		vim.keymap.set("o", "N", "'nN'[v:searchforward]", opts)
		vim.keymap.set("v", "N", "'nN'[v:searchforward]", opts)
		vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", opts)
		vim.keymap.set("o", "n", "'Nn'[v:searchforward]", opts)
		vim.keymap.set("v", "n", "'Nn'[v:searchforward]", opts)
	end,
	buffers = function()
		local opts = { noremap = true }

		opts.desc = "First"
		vim.keymap.set("n", "<leader>bg", "<cmd>bfirst<cr>", opts)

		opts.desc = "Last"
		vim.keymap.set("n", "<leader>bG", "<cmd>blast<cr>", opts)

		opts.desc = "Keep this"
		vim.keymap.set("n", "<leader>bk", "<cmd>wall!<bar>%bdelete<bar>edit#<bar>bdelete#<cr>", opts)

		opts.desc = "Delete"
		vim.keymap.set("n", "<leader>bd", require("mini.bufremove").delete, opts)

		opts.desc = "Wipeout"
		vim.keymap.set("n", "<leader>bw", require("mini.bufremove").wipeout, opts)
	end,
	copilot = function()
		local opts = { noremap = true }

		opts.desc = "Quick chat"
		vim.keymap.set("v", "<leader>cc", ":CopilotChat<cr>", opts)
		vim.keymap.set("n", "<leader>cc", function()
			vim.ui.input({ prompt = "Quick Chat: " }, function(input)
				if input ~= "" then
					require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
				else
					vim.notify("Chat cannot be empty", vim.log.levels.ERROR)
				end
			end)
		end, opts)

		opts.desc = "Toggle chat"
		vim.keymap.set("n", "<leader>ct", "<cmd>CopilotChatToggle<cr>", opts)

		opts.desc = "Stop chat"
		vim.keymap.set("n", "<leader>cs", "<cmd>CopilotChatStop<cr>", opts)

		opts.desc = "Reset chat"
		vim.keymap.set("n", "<leader>cr", "<cmd>CopilotChatReset<cr>", opts)

		opts.desc = "Explain"
		vim.keymap.set({ "n", "v" }, "<leader>ce", ":CopilotChatExplain<cr>", opts)

		opts.desc = "Fix"
		vim.keymap.set({ "n", "v" }, "<leader>cf", ":CopilotChatFix<cr>", opts)

		opts.desc = "Optimize"
		vim.keymap.set({ "n", "v" }, "<leader>co", ":CopilotChatOptimize<cr>", opts)

		opts.desc = "Generate docs"
		vim.keymap.set({ "n", "v" }, "<leader>cd", ":CopilotChatDocs<cr>", opts)

		opts.desc = "Generate tests"
		vim.keymap.set({ "n", "v" }, "<leader>cT", ":CopilotChatTests<cr>", opts)

		opts.desc = "Review"
		vim.keymap.set({ "n", "v" }, "<leader>cR", ":CopilotChatReview<cr>", opts)
	end,
	git = function()
		local opts = { noremap = true }

		opts.desc = "Commit"
		vim.keymap.set("n", "<leader>g.", "<cmd>Git commit<cr>", opts)

		opts.desc = "Add (file)"
		vim.keymap.set("n", "<leader>ga", "<cmd>Git add %<cr>", opts)

		opts.desc = "Add (repo)"
		vim.keymap.set("n", "<leader>gA", "<cmd>Git add --all<cr>", opts)

		opts.desc = "Blame"
		vim.keymap.set("n", "<leader>gb", require("snacks").git.blame_line, opts)

		opts.desc = "Commits (file)"
		vim.keymap.set("n", "<leader>gc", function()
			require("mini.extra").pickers.git_commits({ path = vim.fn.expand("%") })
		end, opts)

		opts.desc = "Commits (repo)"
		vim.keymap.set("n", "<leader>gC", require("mini.extra").pickers.git_commits, opts)

		opts.desc = "Diff"
		vim.keymap.set("n", "<leader>gd", "<cmd>Git diff %<cr>", opts)

		opts.desc = "LazyGit"
		vim.keymap.set("n", "<leader>gg", require("snacks").lazygit.open, opts)

		opts.desc = "History"
		vim.keymap.set({ "n", "v" }, "<leader>gh", require("mini.git").show_at_cursor, opts)

		opts.desc = "Hunks"
		vim.keymap.set("n", "<leader>gH", require("mini.extra").pickers.git_hunks, opts)

		opts.desc = "Pull"
		vim.keymap.set("n", "<leader>gp", "<cmd>Git pull<cr>", opts)

		opts.desc = "Push"
		vim.keymap.set("n", "<leader>gP", "<cmd>Git push<cr>", opts)

		opts.desc = "Open in browser"
		vim.keymap.set({ "n", "v" }, "<leader>go", require("snacks").gitbrowse.open, opts)
	end,
	labels = function()
		local opts = { noremap = true }

		opts.desc = "Add label"
		vim.keymap.set("n", "<leader>la", function()
			vim.ui.input({ prompt = "Label: " }, function(input)
				if input == "" or input == nil then
					vim.notify("Label cannot be empty", vim.log.levels.ERROR)
				else
					require("mini.visits").add_label(input)
				end
			end)
		end, opts)

		opts.desc = "Delete label"
		vim.keymap.set("n", "<leader>ld", function()
			vim.ui.select(require("mini.visits").list_labels(), { prompt = "Select label: " }, function(choosed)
				require("mini.visits").remove_label(choosed)
			end)
		end, opts)

		opts.desc = "List labels"
		vim.keymap.set("n", "<leader>ll", require("mini.extra").pickers.visit_labels, opts)
	end,
	macros = function()
		local opts = { noremap = true, expr = true }

		opts.desc = "Record macro"
		vim.keymap.set("n", "Q", "@q", opts)

		opts.desc = "Replace with macro"
		vim.keymap.set("v", "Q", ":norm @q<cr>", opts)
	end,
	notes = function()
		local opts = { noremap = true }

		opts.desc = "Search"
		vim.keymap.set("n", "<leader>ns", require("notes").search, opts)

		opts.desc = "Live grep"
		vim.keymap.set("n", "<leader>n/", require("notes").grep_live, opts)

		opts.desc = "New"
		vim.keymap.set("n", "<leader>nn", require("notes").new, opts)
	end,
	todotxt = function()
		local opts = { noremap = true }

		opts.desc = "Open"
		vim.keymap.set("n", "<leader>tt", require("todotxt").open_todo_file, opts)

		opts.desc = "New entry"
		vim.keymap.set("n", "<leader>tn", require("todotxt").capture_todo, opts)
	end,
	slime = function()
		local opts = { noremap = true }

		opts.desc = "Slime: send to terminal"
		vim.keymap.set("n", "<c-c><c-c>", "<Plug>SlimeParagraphSend", opts)
		vim.keymap.set("v", "<c-c><c-c>", "<Plug>SlimeRegionSend", opts)

		opts.desc = "Slime: settings"
		vim.keymap.set("n", "<c-c><c-s>", "<Plug>SlimeConfig", opts)
	end,
	smart_splits = function()
		local opts = { desc = "Smart splits" }

		opts.desc = "Smart splits: move cursor"
		vim.keymap.set({ "n", "t" }, "<c-h>", require("smart-splits").move_cursor_left, opts)
		vim.keymap.set({ "n", "t" }, "<c-j>", require("smart-splits").move_cursor_down, opts)
		vim.keymap.set({ "n", "t" }, "<c-k>", require("smart-splits").move_cursor_up, opts)
		vim.keymap.set({ "n", "t" }, "<c-l>", require("smart-splits").move_cursor_right, opts)

		opts.desc = "Smart splits: resize panes"
		vim.keymap.set({ "n", "t" }, "<a-h>", require("smart-splits").resize_left, opts)
		vim.keymap.set({ "n", "t" }, "<a-j>", require("smart-splits").resize_down, opts)
		vim.keymap.set({ "n", "t" }, "<a-k>", require("smart-splits").resize_up, opts)
		vim.keymap.set({ "n", "t" }, "<a-l>", require("smart-splits").resize_right, opts)

		opts.desc = "Smart splits: swap buffer"
		vim.keymap.set("n", "<c-left>", require("smart-splits").swap_buf_left, opts)
		vim.keymap.set("n", "<c-down>", require("smart-splits").swap_buf_down, opts)
		vim.keymap.set("n", "<c-up>", require("smart-splits").swap_buf_up, opts)
		vim.keymap.set("n", "<c-right>", require("smart-splits").swap_buf_right, opts)
	end,
	tabs = function()
		local opts = { noremap = true }

		opts.desc = "Previous"
		vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>", opts)

		opts.desc = "Next"
		vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>", opts)

		opts.desc = "Last"
		vim.keymap.set("n", "<leader><tab>G", "<cmd>tablast<cr>", opts)

		opts.desc = "Close"
		vim.keymap.set("n", "<leader><tab>q", "<cmd>tabclose<cr>", opts)

		opts.desc = "First"
		vim.keymap.set("n", "<leader><tab>g", "<cmd>tabfirst<cr>", opts)

		opts.desc = "Keep"
		vim.keymap.set("n", "<leader><tab>k", "<cmd>tabonly<cr>", opts)

		opts.desc = "New"
		vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>", opts)

		opts.desc = "Edit"
		vim.keymap.set("n", "<leader><tab>e", "<cmd>tabedit %<cr>", opts)
	end,
}

M.lsp = function(client, bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "LSP: go to next reference"
	vim.keymap.set("n", "]r", function()
		require("snacks").words.jump(vim.v.count1)
	end, opts)

	opts.desc = "LSP: go to previous reference"
	vim.keymap.set("n", "[r", function()
		require("snacks").words.jump(-vim.v.count1)
	end, opts)

	if client.supports_method("textDocument/rename") then
		opts.desc = "LSP: rename symbol"
		vim.keymap.set("n", "<f2>", vim.lsp.buf.rename, opts)
	end

	if client.supports_method("textDocument/definition") then
		opts.desc = "LSP: go to definition"
		vim.keymap.set("n", "gd", function()
			require("mini.extra").pickers.lsp({ scope = "definition" })
		end, opts)
	end

	if client.supports_method("textDocument/declaration") then
		opts.desc = "LSP: go to declaration"
		vim.keymap.set("n", "gD", function()
			require("mini.extra").pickers.lsp({ scope = "declaration" })
		end, opts)
	end

	if client.supports_method("textDocument/implementation") then
		opts.desc = "LSP: go to implementations"
		vim.keymap.set("n", "gi", function()
			require("mini.extra").pickers.lsp({ scope = "implementation" })
		end, opts)
	end

	if client.supports_method("textDocument/references") then
		opts.desc = "LSP: go to references"
		vim.keymap.set("n", "gr", function()
			require("mini.extra").pickers.lsp({ scope = "references" })
		end, opts)
	end

	if client.supports_method("textDocument/typeDefinition") then
		opts.desc = "LSP: go to type definition"
		vim.keymap.set("n", "gt", function()
			require("mini.extra").pickers.lsp({ scope = "type_definition" })
		end, opts)
	end

	if client.supports_method("textDocument/codeAction") then
		opts.desc = "LSP: code actions"
		vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, opts)
	end

	if client.supports_method("textDocument/publishDiagnostics") then
		opts.desc = "LSP: diagnostics"
		vim.keymap.set("n", "<leader>d", require("mini.extra").pickers.diagnostic, opts)

		opts.desc = "LSP: diagnostics (float)"
		vim.keymap.set("n", "<leader>f", vim.diagnostic.open_float, opts)
	end

	if client.supports_method("textDocument/signatureHelp") then
		opts.desc = "LSP: signature help"
		vim.keymap.set("n", "<leader>h", vim.lsp.buf.signature_help, opts)
	end

	if client.supports_method("textDocument/inlayHint") then
		opts.desc = "LSP: toggle inlay hints"
		vim.keymap.set("n", "<leader>i", require("snacks").toggle.inlay_hints, opts)
	end

	if client.supports_method("textDocument/hover") then
		opts.desc = "LSP: hover"
		vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts)
	end

	if client.supports_method("textDocument/documentSymbol") then
		opts.desc = "LSP: symbols (document)"
		vim.keymap.set("n", "<leader>s", function()
			require("mini.extra").pickers.lsp({ scope = "document_symbol" })
		end, opts)
	end

	if client.supports_method("workspace/symbol") then
		opts.desc = "LSP: symbols (workspace)"
		vim.keymap.set("n", "<leader>S", function()
			require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
		end, opts)
	end
end

M.dap = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "DAP: step out"
	vim.keymap.set("n", "<localleader>o", require("dap").step_out, opts)

	opts.desc = "DAP: step into"
	vim.keymap.set("n", "<localleader>i", require("dap").step_into, opts)

	opts.desc = "DAP: step back"
	vim.keymap.set("n", "<f7>", require("dap").step_back, opts)

	opts.desc = "DAP: continue"
	vim.keymap.set("n", "<f8>", require("dap").continue, opts)

	opts.desc = "DAP: step over"
	vim.keymap.set("n", "<f9>", require("dap").step_over, opts)

	opts.desc = "DAP: pause"
	vim.keymap.set("n", "<s-f8>", require("dap").pause, opts)

	opts.desc = "DAP: toggle breakpoint"
	vim.keymap.set("n", "<localleader>b", require("dap").toggle_breakpoint, opts)

	opts.desc = "DAP: debug last"
	vim.keymap.set("n", "<localleader><bs>", require("dap").run_last, opts)

	opts.desc = "DAP: clear all breakpoints"
	vim.keymap.set("n", "<localleader>C", require("dap").clear_breakpoints, opts)

	opts.desc = "DAP: terminate"
	vim.keymap.set("n", "<localleader>B", require("dap").terminate, opts)

	opts.desc = "DAP: show hover"
	vim.keymap.set("n", "<localleader>k", require("dap.ui.widgets").hover, opts)

	opts.desc = "DAP: toggle UI"
	vim.keymap.set("n", "<localleader>u", require("dapui").toggle, opts)

	opts.desc = "DAP: eval"
	vim.keymap.set("n", "<localleader>e", function()
		require("dapui").eval(nil, { enter = true })
	end, opts)

	opts.desc = "DAP: conditional breakpoint"
	vim.keymap.set("n", "<localleader>B", function()
		require("dap").set_breakpoint(vim.fn.input("Condition: "))
	end, opts)
end

M.refactoring = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "Refactoring"
	vim.keymap.set({ "n", "x" }, "<leader>r", require("refactoring").select_refactor, opts)
end

M.markdown = function(bufnr)
	local opts = { buffer = bufnr }

	opts.desc = "Markdown: add item below"
	vim.keymap.set({ "n", "i" }, "<c-c><c-j>", "<cmd>MDListItemBelow<cr>", opts)

	opts.desc = "Markdown: add item above"
	vim.keymap.set({ "n", "i" }, "<c-c><c-k>", "<cmd>MDListItemAbove<cr>", opts)

	opts.desc = "Markdown: toggle checkbox"
	vim.keymap.set({ "n", "v" }, "<c-c><c-x>", ":MDTaskToggle<cr>", opts)

	opts.desc = "Markdown: toggle italic"
	vim.keymap.set("v", "<c-i>", require("utils").toggle_emphasis("i"), opts)

	opts.desc = "Markdown: toggle bold"
	vim.keymap.set("v", "<c-b>", require("utils").toggle_emphasis("b"), opts)

	opts.desc = "Markdown: preview document"
	vim.keymap.set("n", "<leader>p", "<cmd>MarkdownPreviewToggle<cr>", opts)
end

M.python = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "Python: test function/method"
	vim.keymap.set("n", "<localleader>f", require("dap-python").test_method, opts)

	opts.desc = "Python: test class"
	vim.keymap.set("n", "<localleader>c", require("dap-python").test_class, opts)

	opts.desc = "Python: debug selection"
	vim.keymap.set("v", "<localleader>s", require("dap-python").debug_selection, opts)
end

M.lua = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "Lua: source file"
	vim.keymap.set("n", "<localleader>%", "<cmd>source %<cr>", opts)

	opts.desc = "Lua: run line"
	vim.keymap.set("n", "<localleader>.", ":.lua<cr>", opts)

	opts.desc = "Lua: run"
	vim.keymap.set("v", "<localleader>.", ":lua<cr>", opts)

	opts.desc = "Lua: run DAP server"
	vim.keymap.set("n", "<localleader>l", function()
		require("osv").launch({ port = 8086 })
	end, opts)
end

M.mini = {
	files = function(event)
		local opts = { noremap = true, buffer = event.data.buf_id }

		vim.keymap.set("n", ".", require("utils").mini.files.toggle_dotfiles, opts)
		vim.keymap.set("n", "go", require("utils").mini.files.open_files, opts)
		vim.keymap.set("n", "<leader>.", require("utils").mini.files.set_cwd, opts)
		vim.keymap.set("n", "<leader>-", require("utils").mini.files.map_split("horizontal", true), opts)
		vim.keymap.set("n", "<leader>\\", require("utils").mini.files.map_split("vertical", true), opts)
	end,
}

M.rest = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "Rest: run"
	vim.keymap.set("n", "<leader>r", "<cmd>Rest run<cr>", opts)
end

M.todotxt = function(bufnr)
	local opts = { noremap = true, buffer = bufnr }

	opts.desc = "todo.txt: toggle task state"
	vim.keymap.set("n", "<c-c><c-x>", require("todotxt").toggle_todo_state, opts)

	opts.desc = "todo.txt: cycle priority"
	vim.keymap.set("n", "<c-c><c-p>", require("todotxt").cycle_priority, opts)

	opts.desc = "Sort"
	vim.keymap.set("n", "<leader>ts", require("todotxt").sort_tasks, opts)

	opts.desc = "Sort by (priority)"
	vim.keymap.set("n", "<leader>tP", require("todotxt").sort_tasks_by_priority, opts)

	opts.desc = "Sort by @context"
	vim.keymap.set("n", "<leader>tc", require("todotxt").sort_tasks_by_context, opts)

	opts.desc = "Sort by +project"
	vim.keymap.set("n", "<leader>tp", require("todotxt").sort_tasks_by_project, opts)

	opts.desc = "Sort by due:date"
	vim.keymap.set("n", "<leader>tD", require("todotxt").sort_tasks_by_due_date, opts)

	opts.desc = "Move to done.txt"
	vim.keymap.set("n", "<leader>td", require("todotxt").move_done_tasks, opts)
end

M.ltex = function(client, bufnr)
	local opts = { buffer = bufnr }

	opts.desc = "Add word to dictionary"
	vim.keymap.set({ "n", "x" }, "zg", function()
		local word = vim.fn.expand("<cword>")

		local words = require("utils").add_word_to_dictionary(vim.g.ltex_language, word)

		local settings = client.config.settings

		if not settings then
			return
		end

		settings.ltex.dictionary[vim.g.ltex_language] = words

		client.notify("workspace/didChangeConfiguration", { settings = settings })
	end, opts)
end

M.setup = function()
	for _, fn in pairs(keys) do
		fn()
	end
end

return M
