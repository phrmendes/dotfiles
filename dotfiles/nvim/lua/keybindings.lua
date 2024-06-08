local augroups = require("utils").augroups
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

local keybindings = {}

keybindings.std = {
	random = function()
		local opts = { noremap = true }

		opts.desc = "Half page down"
		map("n", "<c-d>", "<c-d>zz", opts)

		opts.desc = "Half page up"
		map("n", "<c-u>", "<c-u>zz", opts)

		opts.desc = "Clear highlights"
		map("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

		opts.desc = "Exit insert mode"
		map("i", "jj", "<esc>", opts)

		opts.desc = "Exit terminal mode"
		map("t", "<esc><esc>", "<c-\\><c-n>", opts)

		opts.desc = "Replay macro"
		map("n", "Q", "@q", opts)

		opts.desc = "Replay macro (visual)"
		map("x", "Q", "<cmd>norm @q<cr>", opts)

		opts.desc = "Resizing"
		map("n", "-", "<c-w><", opts)
		map("n", "=", "<c-w>>", opts)
		map("n", "_", "<c-w>-", opts)
		map("n", "+", "<c-w>+", opts)
	end,
	leader = function()
		local opts = { noremap = true }

		opts.desc = "Split (H)"
		map("n", "<leader>-", "<cmd>split<cr>", opts)

		opts.desc = "Split (V)"
		map("n", "<leader>\\", "<cmd>vsplit<cr>", opts)

		opts.desc = "Command history"
		map("n", "<leader>:", function()
			require("mini.extra").pickers.history({ scope = ":" })
		end, opts)

		opts.desc = "Resize and make windows equal"
		map("n", "<leader>=", "<c-w>=", opts)

		opts.desc = "Help"
		map("n", "<leader>?", require("mini.pick").builtin.help, opts)

		opts.desc = "Find"
		map("n", "<leader><leader>", require("mini.pick").builtin.files, opts)

		opts.desc = "Live grep"
		map("n", "<leader>G", require("mini.pick").builtin.grep_live, opts)

		opts.desc = "Keymaps"
		map("n", "<leader>K", require("mini.extra").pickers.keymaps, opts)

		opts.desc = "Quit all"
		map("n", "<leader>Q", "<cmd>qall!<cr>", opts)

		opts.desc = "Write all"
		map("n", "<leader>W", "<cmd>wall!<cr>", opts)

		opts.desc = "Close all other windows"
		map("n", "<leader>X", "<c-w>o", opts)

		opts.desc = "Paste image"
		map("n", "<leader>i", "<cmd>PasteImage<cr>", opts)

		opts.desc = "Undo tree"
		map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", opts)

		opts.desc = "Quit"
		map("n", "<leader>q", "<cmd>q<cr>", opts)

		opts.desc = "Visits"
		map("n", "<leader>v", require("mini.extra").pickers.visit_paths, opts)

		opts.desc = "Write"
		map("n", "<leader>w", "<cmd>w<cr>", opts)

		opts.desc = "Close window"
		map("n", "<leader>x", "<c-w>q", opts)
	end,
	better_keys = function()
		local opts = { expr = true, noremap = true, silent = true, desc = "Better keys" }

		map("n", "N", "'nN'[v:searchforward].'zv'", opts)
		map("o", "N", "'nN'[v:searchforward]", opts)
		map("x", "N", "'nN'[v:searchforward]", opts)
		map("n", "n", "'Nn'[v:searchforward].'zv'", opts)
		map("o", "n", "'Nn'[v:searchforward]", opts)
		map("x", "n", "'Nn'[v:searchforward]", opts)
		map("n", "j", [[v:count == 0 ? 'gj' : 'j']], opts)
		map("n", "k", [[v:count == 0 ? 'gk' : 'k']], opts)
	end,
	buffers = function()
		local opts = { noremap = true }

		opts.desc = "List"
		map("n", "<leader>bb", require("mini.pick").builtin.buffers, opts)

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

		map("n", "g<c-a>", function()
			require("dial.map").manipulate("increment", "gnormal")
		end, opts)

		map("n", "g<c-x>", function()
			require("dial.map").manipulate("decrement", "gnormal")
		end, opts)

		map("v", "<c-a>", function()
			require("dial.map").manipulate("increment", "visual")
		end, opts)

		map("v", "<c-x>", function()
			require("dial.map").manipulate("decrement", "visual")
		end, opts)

		map("v", "g<c-a>", function()
			require("dial.map").manipulate("increment", "gvisual")
		end, opts)

		map("v", "g<c-x>", function()
			require("dial.map").manipulate("decrement", "gvisual")
		end, opts)
	end,
	explorer = function()
		local opts = { noremap = true }

		opts.desc = "Explorer (current file)"
		map("n", "<leader>e", function()
			if not require("mini.files").close() then
				require("mini.files").open(vim.fn.expand("%:p:h"))
			end

			require("mini.files").reveal_cwd()
		end, opts)

		opts.desc = "Explorer (cwd)"
		map("n", "<leader>E", function()
			if not require("mini.files").close() then
				require("mini.files").open(vim.fn.getcwd())
			end
		end, opts)
	end,
	git = function()
		local opts = { noremap = true }

		opts.desc = "Add (file)"
		map("n", "<leader>ga", "<cmd>Git add %<cr>", opts)

		opts.desc = "Add (repo)"
		map("n", "<leader>gA", "<cmd>Git add .<cr>", opts)

		opts.desc = "Commit"
		map("n", "<leader>gc", function()
			require("neogit").open({ "commit" })
		end, opts)

		opts.desc = "Diff (file)"
		map({ "n", "v" }, "<leader>gd", "<cmd>DiffviewFileHistory<cr>", opts)

		opts.desc = "Diff (repo)"
		map({ "n", "v" }, "<leader>gD", "<cmd>DiffviewOpen<cr>", opts)

		opts.desc = "Neogit"
		map("n", "<leader>gg", require("neogit").open, opts)

		opts.desc = "Pull"
		map("n", "<leader>gp", "<cmd>Git pull<cr>", opts)

		opts.desc = "Push"
		map("n", "<leader>gP", "<cmd>Git push<cr>", opts)
	end,
	notes = function()
		local opts = { noremap = true }

		opts.desc = "New note"
		map("n", "<leader>nn", "<cmd>NewNote<cr>", opts)

		opts.desc = "Search note"
		map("n", "<leader>ns", "<cmd>SearchNote<cr>", opts)

		opts.desc = "Live grep in notes"
		map("n", "<leader>ng", "<cmd>GrepNotes<cr>", opts)

		opts.desc = "Open inbox"
		map("n", "<leader>ni", "<cmd>Inbox<cr>", opts)

		opts.desc = "Open todo.txt"
		map("n", "<leader>nt", "<cmd>TodoTxt<cr>", opts)
	end,
	tabs = function()
		local opts = { noremap = true }

		opts.desc = "Previous tab"
		map("n", "[<tab>", "<cmd>tabprevious<cr>", opts)

		opts.desc = "Next tab"
		map("n", "]<tab>", "<cmd>tabnext<cr>", opts)

		opts.desc = "Last tab"
		map("n", "<leader><tab>G", "<cmd>tablast<cr>", opts)

		opts.desc = "Close tab"
		map("n", "<leader><tab>q", "<cmd>tabclose<cr>", opts)

		opts.desc = "First tab"
		map("n", "<leader><tab>g", "<cmd>tabfirst<cr>", opts)

		opts.desc = "Keep only this tab"
		map("n", "<leader><tab>k", "<cmd>tabonly<cr>", opts)

		opts.desc = "New tab"
		map("n", "<leader><tab>n", "<cmd>tabnew<cr>", opts)

		opts.desc = "Edit in tab"
		map("n", "<leader><tab>e", "<cmd>tabedit %<cr>", opts)
	end,
}

keybindings.lsp = function(event)
	local opts = { noremap = true, buffer = event.buf }
	local client = vim.lsp.get_client_by_id(event.data.client_id)

	if client then
		if client.supports_method("textDocument/rename") then
			opts.desc = "[LSP] Rename"
			map("n", "<f2>", vim.lsp.buf.rename, opts)
		end

		if client.supports_method("textDocument/definition") then
			opts.desc = "[LSP] Go to definition"
			map("n", "gd", function()
				require("mini.extra").pickers.lsp({ scope = "definition" })
			end, opts)
		end

		if client.supports_method("textDocument/declaration") then
			opts.desc = "[LSP] Go to declaration"
			map("n", "gD", function()
				require("mini.extra").pickers.lsp({ scope = "declaration" })
			end, opts)
		end

		if client.supports_method("textDocument/implementation") then
			opts.desc = "[LSP] Go to implementation"
			map("n", "gi", function()
				require("mini.extra").pickers.lsp({ scope = "implementation" })
			end, opts)
		end

		if client.supports_method("textDocument/references") then
			opts.desc = "[LSP] Go to references"
			map("n", "gr", function()
				require("mini.extra").pickers.lsp({ scope = "references" })
			end, opts)
		end

		if client.supports_method("textDocument/typeDefinition") then
			opts.desc = "[LSP] Go to type definition"
			map("n", "gt", function()
				require("mini.extra").pickers.lsp({ scope = "type_definition" })
			end, opts)
		end

		if client.supports_method("textDocument/codeAction") then
			opts.desc = "[LSP] Code actions"
			map({ "n", "x" }, "<leader>a", require("actions-preview").code_actions, opts)
		end

		if client.supports_method("textDocument/publishDiagnostics") then
			opts.desc = "[LSP] Diagnostics"
			map("n", "<leader>d", require("mini.extra").pickers.diagnostic, opts)
		end

		if client.supports_method("textDocument/signatureHelp") then
			opts.desc = "[LSP] Signature help"
			map("n", "<leader>h", vim.lsp.buf.signature_help, opts)
		end

		if client.supports_method("textDocument/hover") then
			opts.desc = "[LSP] Hover"
			map("n", "<leader>k", vim.lsp.buf.hover, opts)
		end

		if client.supports_method("textDocument/documentSymbol") then
			opts.desc = "[LSP] Symbols (document)"
			map("n", "<leader>s", function()
				require("mini.extra").pickers.lsp({ scope = "document_symbol" })
			end, opts)
		end

		if client.supports_method("workspace/symbol") then
			opts.desc = "[LSP] Symbols (workspace)"
			map("n", "<leader>S", function()
				require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
			end, opts)
		end
	end
end

keybindings.dap = function(event)
	local opts = { noremap = true, buffer = event.buf }

	opts.desc = "[DAP] step out"
	map("n", "<f3>", require("dap").step_out, opts)

	opts.desc = "[DAP] step into"
	map("n", "<f4>", require("dap").step_into, opts)

	opts.desc = "[DAP] step back"
	map("n", "<f5>", require("dap").step_back, opts)

	opts.desc = "[DAP] continue"
	map("n", "<f6>", require("dap").continue, opts)

	opts.desc = "[DAP] step over"
	map("n", "<f7>", require("dap").step_over, opts)

	opts.desc = "[DAP] pause"
	map("n", "<s-f6>", require("dap").pause, opts)

	opts.desc = "[DAP] terminate"
	map("n", "<del>", require("dap").terminate, opts)

	opts.desc = "[DAP] breakpoint"
	map("n", "<localleader>b", require("dap").toggle_breakpoint, opts)

	opts.desc = "[DAP] debug last"
	map("n", "<localleader><bs>", require("dap").run_last, opts)

	opts.desc = "[DAP] clear all breakpoints"
	map("n", "<localleader><del>", require("dap").clear_breakpoints, opts)

	opts.desc = "[DAP] show hover"
	map("n", "<localleader>k", require("dap.ui.widgets").hover, opts)

	opts.desc = "[DAP] toggle UI"
	map("n", "<localleader>u", require("dapui").toggle, opts)

	opts.desc = "[DAP] eval"
	map("n", "<localleader><cr>", require("dapui").eval, opts)

	opts.desc = "[DAP] conditional breakpoint"
	map("n", "<localleader>B", function()
		require("dap").set_breakpoint(vim.fn.input("Condition: "))
	end, opts)
end

keybindings.neogen = function(event)
	local opts = { noremap = true, buffer = event.buf }

	opts.desc = "[neogen] Generate documentation"
	map("n", "<localleader>g", require("neogen").generate, opts)
end

keybindings.refactor = function(event)
	local opts = { noremap = true, buffer = event.buf }

	opts.desc = "[Refactor] Select"
	map({ "n", "x" }, "<leader>r", function()
		require("refactoring").select_refactor()
	end, opts)

	opts.desc = "[Refactor] Print variable"
	map("n", "<leader>p", function()
		require("refactoring").debug.print_var()
	end, opts)

	opts.desc = "[Refactor] Clean print statements"
	map("n", "<leader>c", function()
		require("refactoring").debug.cleanup()
	end, opts)
end

keybindings.writing = function(event)
	local opts = { noremap = true, buffer = event.buf }

	local function toggle(key)
		return [[<esc>gv<cmd>lua require("markdown.inline").toggle_emphasis_visual]] .. key .. "<cr>"
	end

	opts.desc = "Markdown"
	map({ "n", "x" }, "<cr>", "<cmd>MDTaskToggle<cr>", opts)
	map("i", "<c-cr>", "<cmd>MDListItemBelow<cr>", opts)
	map("i", "<s-cr>", "<cmd>MDListItemAbove<cr>", opts)
	map("x", "<c-b>", toggle("b"), opts)
	map("x", "<c-i>", toggle("i"), opts)

	opts.desc = "Preview markdown"
	map("n", "<leader>m", "<cmd>MarkdownPreviewToggle<cr>", opts)

	opts.desc = "Preview equation"
	map("n", "<leader>p", require("nabla").popup, opts)

	opts.desc = "[Zotero] Citation info"
	map("n", "<c-i>", "<Plug>ZCitationInfo", opts)

	opts.desc = "[Zotero] Citation info (complete)"
	map("n", "<c-s-i>", "<Plug>ZCitationCompleteInfo", opts)

	opts.desc = "[Zotero] Open attachment"
	map("n", "<c-o>", "<Plug>ZOpenAttachment", opts)

	opts.desc = "[Zotero] View document"
	map("n", "<c-s-o>", "<Plug>ZViewDocument", opts)

	opts.desc = "[Zotero] YAML reference"
	map("n", "<c-y>", "<Plug>ZCitationYamlRef", opts)
end

keybindings.ft = {
	dbui = function(event)
		local opts = { noremap = true, buffer = event.buf }

		opts.desc = "[dadbod] Execute query"
		map("n", "<cr>", "<Plug>(DBUI_ExecuteQuery)", opts)

		opts.desc = "[dadbod] Select line"
		map("n", "<tab>", "<Plug>(DBUI_SelectLine)", opts)

		opts.desc = "[dadbod] Toggle details"
		map("n", "K", "<Plug>(DBUI_ToggleDetails)", opts)

		opts.desc = "[dadbod] Redraw"
		map("n", "R", "<Plug>(DBUI_Redraw)", opts)

		opts.desc = "[dadbod] Delete line"
		map("n", "d", "<Plug>(DBUI_DeleteLine)", opts)

		opts.desc = "[dadbod] Insert line"
		map("n", "q", "<Plug>(DBUI_Quit)", opts)

		opts.desc = "[dadbod] Rename line"
		map("n", "r", "<Plug>(DBUI_RenameLine)", opts)

		opts.desc = "[dadbod] Toggle result layout"
		map("n", "t", "<Plug>(DBUI_ToggleResultLayout)", opts)

		opts.desc = "[dadbod] Save query"
		map("n", "w", "<Plug>(DBUI_SaveQuery)", opts)
	end,
	http = function(event)
		local opts = { noremap = true, buffer = event.buf }

		opts.desc = "[REST] Run request under the cursor"
		map("n", "<localleader>r", "<cmd>Rest run<cr>", opts)

		opts.desc = "[REST] Re-run latest request"
		map("n", "<localleader>R", "<cmd>Rest run last<cr>", opts)
	end,
	lua = function(event)
		keybindings.dap(event)
		keybindings.neogen(event)
		keybindings.refactor(event)

		local opts = { noremap = true, buffer = event.buf }

		opts.desc = "[DAP] Launch debugger"
		map("n", "<localleader>l", require("osv").launch({ port = 8086 }), opts)
	end,
	go = function(event)
		keybindings.dap(event)
		keybindings.neogen(event)
		keybindings.refactor(event)

		local opts = { noremap = true, buffer = event.buf }

		opts.desc = "[DAP] debug test"
		map("n", "<localleader>t", require("dap-go").debug_test, opts)

		opts.desc = "[DAP] debug last test"
		map("n", "<localleader>T", require("dap-go").debug_last_test, opts)

		opts.desc = "[Go] Add json struct tags"
		map("n", "<leader>j", "<cmd>GoTagAdd json<cr>", opts)

		opts.desc = "[Go] Add yaml struct tags"
		map("n", "<leader>y", "<cmd>GoTagAdd yaml<cr>", opts)
	end,
	markdown = function(event)
		keybindings.writing(event)
	end,
	python = function(event)
		keybindings.dap(event)
		keybindings.neogen(event)
		keybindings.refactor(event)

		local opts = { noremap = true, buffer = event.buf }

		opts.desc = "[DAP] Debug function/method"
		map("n", "<localleader>f", require("dap-python").test_method, opts)

		opts.desc = "[DAP] Debug class"
		map("n", "<localleader>c", require("dap-python").test_class, opts)

		opts.desc = "[DAP] Debug selection"
		map("x", "<localleader>s", require("dap-python").debug_selection, opts)
	end,
	quarto = function(event)
		keybindings.writing(event)
	end,
	todo = function(event)
		local opts = { script = true, silent = true, buffer = event.buf }

		opts.desc = "[todo.txt] Sort"
		map({ "n", "v" }, "<localleader>s", "<cmd>%sort<cr>", opts)

		opts.desc = "Sort by +project"
		map({ "n", "v" }, "<localleader>s+", "<cmd>%call todo#txt#sort_by_project()<cr>", opts)

		opts.desc = "Sort by @context"
		map({ "n", "v" }, "<localleader>s@", "<cmd>%call todo#txt#sort_by_context()<cr>", opts)

		opts.desc = "Sort by date"
		map({ "n", "v" }, "<localleader>sd", "<cmd>%call todo#txt#sort_by_date()<cr>", opts)

		opts.desc = "Sort by due date"
		map({ "n", "v" }, "<localleader>sdd", "<cmd>%call todo#txt#sort_by_due_date()<cr>", opts)

		opts.desc = "[todo.txt] Decrease priority"
		map({ "n", "v" }, "<localleader>k", "<cmd>call todo#txt#prioritize_decrease()<cr>", opts)

		opts.desc = "[todo.txt] Increase priority"
		map({ "n", "v" }, "<localleader>j", "<cmd>call todo#txt#prioritize_increase()<cr>", opts)

		opts.desc = "[todo.txt] Add priority (A)"
		map({ "n", "v" }, "<localleader>a", "<cmd>call todo#txt#prioritize_add('A')<cr>", opts)

		opts.desc = "[todo.txt] Add priority (B)"
		map({ "n", "v" }, "<localleader>b", "<cmd>call todo#txt#prioritize_add('B')<cr>", opts)

		opts.desc = "[todo.txt] Add priority (C)"
		map({ "n", "v" }, "<localleader>c", "<cmd>call todo#txt#prioritize_add('C')<cr>", opts)

		opts.desc = "[todo.txt] Insert date"
		map("i", "date<tab>", "<c-r>=strftime('%Y-%m-%d')<cr>", opts)
		map("n", "<localleader>d", "<cmd>call todo#txt#replace_date()<cr>", opts)
		map("v", "<localleader>d", "<cmd>call todo#txt#replace_date()<cr>", opts)

		opts.desc = "[todo.txt] Mark as done"
		map({ "n", "v" }, "<localleader>x", "<cmd>call todo#txt#mark_as_done()<cr>", opts)

		opts.desc = "[todo.txt] Mark all as done"
		map("n", "<localleader>X", "<cmd>call todo#txt#mark_all_as_done()<cr>", opts)

		opts.desc = "[todo.txt] Remove completed"
		map("n", "<localleader>D", "<cmd>call todo#txt#remove_completed()<cr>", opts)
	end,
}

for _, func in pairs(keybindings.std) do
	func()
end

autocmd("LspAttach", {
	group = augroups.lsp.attach,
	callback = keybindings.lsp,
})

for ft, func in pairs(keybindings.ft) do
	autocmd("FileType", {
		group = augroups.filetype,
		pattern = ft,
		callback = func,
	})
end
