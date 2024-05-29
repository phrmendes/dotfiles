local wk = require("which-key")
local augroups = require("utils").augroups
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

local keybindings = {}

vim.g.VM_maps = {
	["Add Cursor Down"] = "m",
	["Add Cursor Up"] = "M",
}

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
		map("i", "jk", "<esc>", opts)

		opts.desc = "Exit terminal mode"
		map("t", "<c-c><c-c>", "<c-\\><c-n>", opts)

		opts.desc = "Replay macro"
		map("n", "Q", "@q", opts)

		opts.desc = "Replay macro (visual)"
		map("x", "Q", "<cmd>norm @q<cr>", opts)

		opts.desc = "Split (H)"
		map("n", "<leader>-", "<cmd>split<cr>", opts)

		opts.desc = "Split (V)"
		map("n", "<leader>\\", "<cmd>vsplit<cr>", opts)

		opts.desc = "Command history"
		map("n", "<leader>:", "<cmd>Telescope command_history<cr>", opts)

		opts.desc = "Resize and make windows equal"
		map("n", "<leader>=", "<c-w>=", opts)

		opts.desc = "Commands"
		map("n", "<leader>.", "<cmd>Telescope commands<cr>", opts)

		opts.desc = "Help"
		map("n", "<leader>?", "<cmd>Telescope help_tags<cr>", opts)

		opts.desc = "Find in buffer"
		map("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)

		opts.desc = "Open"
		map("n", "<leader><leader>", "<cmd>Telescope smart_open<cr>", opts)

		opts.desc = "Live grep"
		map("n", "<leader>G", "<cmd>Telescope live_grep<cr>", opts)

		opts.desc = "Keymaps"
		map("n", "<leader>K", "<cmd>Telescope keymaps<cr>", opts)

		opts.desc = "Quit all"
		map("n", "<leader>Q", "<cmd>qall!<cr>", opts)

		opts.desc = "Write all"
		map("n", "<leader>W", "<cmd>wall!<cr>", opts)

		opts.desc = "Close all other windows"
		map("n", "<leader>X", "<c-w>o", opts)

		opts.desc = "Generate annotations"
		map("n", "<leader>n", "<cmd>Neogen<cr>", opts)

		opts.desc = "Paste image"
		map("n", "<leader>p", "<cmd>PasteImage<cr>", opts)

		opts.desc = "Undo tree"
		map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", opts)

		opts.desc = "Quit"
		map("n", "<leader>q", "<cmd>q<cr>", opts)

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

		wk.register({ ["<leader>b"] = { name = "buffers" } })

		opts.desc = "First"
		map("n", "<leader>bg", "<cmd>bfirst<cr>", opts)

		opts.desc = "Last"
		map("n", "<leader>bG", "<cmd>blast<cr>", opts)

		opts.desc = "Keep this"
		map("n", "<leader>bk", "<cmd>%bdelete<bar>edit#<bar>bdelete#<cr>", opts)

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
	file_explorer = function()
		local files = require("mini.files")
		local opts = { noremap = true }

		local explorer = function(path)
			if not files.close() then
				files.open(path)
			end
		end

		opts.desc = "Explorer (current file)"
		map("n", "<leader>e", function()
			explorer(vim.fn.expand("%:p:h"))
			files.reveal_cwd()
		end, opts)

		opts.desc = "Explorer (cwd)"
		map("n", "<leader>E", function()
			explorer(vim.loop.cwd())
		end, opts)
	end,
	git = function()
		local opts = { noremap = true }

		wk.register({ ["<leader>g"] = {
			name = "git",
			mode = { "n", "x" },
		} })

		opts.desc = "LazyGit"
		map("n", "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", opts)

		opts.desc = "List commits (file)"
		map("n", "<leader>gc", "<cmd>Telescope git_bcommits<cr>", opts)

		opts.desc = "List commits (repo)"
		map("n", "<leader>gC", "<cmd>Telescope git_commits<cr>", opts)

		opts.desc = "Add (file)"
		map("n", "<leader>ga", "<cmd>Git add %<cr>", opts)

		opts.desc = "Add (repo)"
		map("n", "<leader>gA", "<cmd>Git add .<cr>", opts)

		opts.desc = "Branches"
		map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", opts)

		opts.desc = "Commit"
		map("n", "<leader>g<cr>", "<cmd>Git commit<cr>", opts)

		opts.desc = "Pull"
		map("n", "<leader>gp", "<cmd>Git pull<cr>", opts)

		opts.desc = "Push"
		map("n", "<leader>gP", "<cmd>Git push<cr>", opts)

		opts.desc = "Blame"
		map("n", "<leader>gl", "<cmd>Git blame %<cr>", opts)

		opts.desc = "Diff"
		map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", opts)

		opts.desc = "File history"
		map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", opts)

		opts.desc = "Show at cursor"
		map({ "n", "x" }, "<leader>gs", require("mini.git").show_at_cursor, opts)
	end,
	rest = function()
		local opts = { noremap = true }

		wk.register({ ["<leader>H"] = { name = "http" } })

		opts.desc = "Run request under cursor"
		map("n", "<leader>Hr", "<cmd>Rest run<cr>", opts)

		opts.desc = "Re-run last request"
		map("n", "<leader>Hl", "<cmd>Rest run last<cr>", opts)

		opts.desc = "Select env"
		map("n", "<leader>Hs", "<cmd>Telescope rest select_env<cr>", opts)
	end,
	sniprun = function()
		local opts = { noremap = true, silent = true }

		opts.desc = "SnipRun"
		map("n", "<leader><cr>", "<Plug>SnipRunOperator", opts)
		map({ "n", "x" }, "<leader><cr>", "<Plug>SnipRun", opts)
	end,
	smart_splits = function()
		local opts = { silent = true, desc = "Smart splits" }

		map({ "n", "i", "t" }, "<c-h>", require("smart-splits").move_cursor_left, opts)
		map({ "n", "i", "t" }, "<c-j>", require("smart-splits").move_cursor_down, opts)
		map({ "n", "i", "t" }, "<c-k>", require("smart-splits").move_cursor_up, opts)
		map({ "n", "i", "t" }, "<c-l>", require("smart-splits").move_cursor_right, opts)
		map({ "n", "i", "t" }, "<c-s-h>", require("smart-splits").resize_left, opts)
		map({ "n", "i", "t" }, "<c-s-j>", require("smart-splits").resize_down, opts)
		map({ "n", "i", "t" }, "<c-s-k>", require("smart-splits").resize_up, opts)
		map({ "n", "i", "t" }, "<c-s-l>", require("smart-splits").resize_right, opts)
		map({ "n", "i", "t" }, "<c-down>", require("smart-splits").swap_buf_down, opts)
		map({ "n", "i", "t" }, "<c-left>", require("smart-splits").swap_buf_left, opts)
		map({ "n", "i", "t" }, "<c-right>", require("smart-splits").swap_buf_right, opts)
		map({ "n", "i", "t" }, "<c-up>", require("smart-splits").swap_buf_up, opts)
	end,
	tabs = function()
		local opts = { noremap = true }

		wk.register({ ["<leader><tab>"] = { name = "tabs" } })

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
	toggleterm = function()
		local opts = { noremap = true, silent = true }

		opts.desc = "Send line to terminal"
		map("n", "<c-c><c-c>", "<cmd>ToggleTermSendCurrentLine<cr>", opts)

		opts.desc = "Send lines to terminal"
		map("x", "<c-c><c-c>", "<cmd>ToggleTermSendVisualSelection<cr>", opts)
	end,
	yanky = function()
		local opts = { noremap = true }

		wk.register({ ["<leader>y"] = { name = "yank" } })

		opts.desc = "History"
		map("n", "<leader>yy", "<cmd>YankyRingHistory<cr>", opts)

		opts.desc = "Clear history"
		map("n", "<leader>yc", "<cmd>YankyClearHistory<cr>", opts)

		opts.desc = "Yank text"
		map({ "n", "x" }, "y", "<Plug>(YankyYank)", opts)

		opts.desc = "Paste after cursor"
		map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", opts)

		opts.desc = "Paste before cursor"
		map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", opts)

		opts.desc = "Paste after selection"
		map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", opts)

		opts.desc = "Paste before selection"
		map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", opts)

		opts.desc = "Previous yank entry"
		map("n", "[y", "<Plug>(YankyPreviousEntry)", opts)

		opts.desc = "Next yank entry"
		map("n", "]y", "<Plug>(YankyNextEntry)", opts)

		opts.desc = "Paste indented after cursor (linewise)"
		map("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", opts)
		map("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", opts)

		opts.desc = "Paste indented before cursor (linewise)"
		map("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", opts)
		map("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", opts)

		opts.desc = "Paste and indent right"
		map("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)", opts)

		opts.desc = "Paste and indent left"
		map("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", opts)

		opts.desc = "Paste before and indent right"
		map("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", opts)

		opts.desc = "Paste before and indent left"
		map("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", opts)

		opts.desc = "Paste after filter"
		map("n", "=p", "<Plug>(YankyPutAfterFilter)", opts)

		opts.desc = "Paste before filter"
		map("n", "=P", "<Plug>(YankyPutBeforeFilter)", opts)
	end,
}

keybindings.lsp = function(event)
	local opts = { noremap = true, buffer = event.buf }

	local desc = function(desc)
		opts.desc = "LSP: " .. desc
	end

	desc("rename")
	map("n", "<F2>", vim.lsp.buf.rename, opts)

	desc("go to declaration")
	map("n", "gD", vim.lsp.buf.declaration, opts)

	desc("go to references")
	map("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)

	desc("go to definition")
	map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)

	desc("go to type definition")
	map("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)

	desc("go to implementations")
	map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)

	desc("code actions")
	map({ "n", "x" }, "<leader>a", require("actions-preview").code_actions, opts)

	desc("diagnostics")
	map("n", "<leader>d", "<cmd>Telescope diagnostics<cr>", opts)

	desc("signature help")
	map("n", "<leader>h", vim.lsp.buf.signature_help, opts)

	desc("hover")
	map("n", "<leader>k", vim.lsp.buf.hover, opts)

	desc("code lens")
	map("n", "<leader>l", vim.lsp.codelens.run, opts)

	desc("symbols (document)")
	map("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", opts)

	desc("symbols (workspace)")
	map("n", "<leader>S", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", opts)
end

keybindings.dap = function(event)
	local opts = { noremap = true, buffer = event.buf }

	wk.register({ ["<leader>d"] = {
		name = "debugger",
		buffer = event.buf,
		mode = { "n", "x" },
	} })

	local desc = function(desc)
		opts.desc = "LSP: " .. desc
	end

	desc("step into")
	map("n", "<f1>", require("dap").step_into, opts)

	desc("step out")
	map("n", "<f3>", require("dap").step_out, opts)

	desc("step back")
	map("n", "<f5>", require("dap").step_back, opts)

	desc("continue")
	map("n", "<f6>", require("dap").continue, opts)

	desc("step over")
	map("n", "<f7>", require("dap").step_over, opts)

	desc("pause")
	map("n", "<s-f6>", require("dap").pause, opts)

	desc("terminate")
	map("n", "<bs>", require("dap").terminate, opts)

	opts.desc = "Breakpoint"
	map("n", "<leader>db", require("dap").toggle_breakpoint, opts)

	opts.desc = "Debug last"
	map("n", "<leader>dl", require("dap").run_last, opts)

	opts.desc = "Clear all breakpoints"
	map("n", "<leader>d<del>", require("dap").clear_breakpoints, opts)

	opts.desc = "Show hover"
	map("n", "<leader>dk", require("dap.ui.widgets").hover, opts)

	opts.desc = "List breakpoints"
	map("n", "<leader>dl", "<cmd>Telescope dap list_breakpoints<cr>", opts)

	opts.desc = "Toggle UI"
	map("n", "<leader>du", require("dapui").toggle, opts)

	opts.desc = "Eval"
	map("n", "<leader>de", require("dapui").eval, opts)

	opts.desc = "Conditional breakpoint"
	map("n", "<leader>dB", function()
		require("dap").set_breakpoint(vim.fn.input("Condition: "))
	end, opts)
end

keybindings.refactor = function(event)
	local opts = { noremap = true, buffer = event.buf }

	wk.register({ ["<leader>r"] = {
		name = "refactor",
		buffer = event.buf,
		mode = { "n", "x" },
	} })

	opts.desc = "Extract function"
	map("x", "<leader>rf", function()
		require("refactoring").refactor("Extract Function")
	end, opts)

	opts.desc = "Extract function to file"
	map("x", "<leader>rF", function()
		require("refactoring").refactor("Extract Function To File")
	end, opts)

	opts.desc = "Extract variable"
	map("x", "<leader>rv", function()
		require("refactoring").refactor("Extract Variable")
	end, opts)

	opts.desc = "Inline function"
	map("n", "<leader>rI", function()
		require("refactoring").refactor("Inline Function")
	end, opts)

	opts.desc = "Inline variable"
	map({ "n", "x" }, "<leader>ri", function()
		require("refactoring").refactor("Inline Variable")
	end, opts)

	opts.desc = "Extract block"
	map("n", "<leader>rb", function()
		require("refactoring").refactor("Extract Block")
	end, opts)

	opts.desc = "Extract block to file"
	map("n", "<leader>rB", function()
		require("refactoring").refactor("Extract Block To File")
	end, opts)

	opts.desc = "Select refactor"
	map({ "n", "x" }, "<leader>rr", function()
		require("telescope").extensions.refactoring.refactors()
	end, opts)

	opts.desc = "Print variable"
	map({ "x", "n" }, "<leader>rp", function()
		require("refactoring").debug.print_var()
	end, opts)

	opts.desc = "Cleanup"
	map("n", "<leader>rc", function()
		require("refactoring").debug.cleanup({})
	end, opts)
end

keybindings.writing = function(event)
	local opts = { noremap = true, buffer = event.buf }

	local function toggle(key)
		return "<Esc>gv<Cmd>lua require'markdown.inline'" .. ".toggle_emphasis_visual'" .. key .. "'<CR>"
	end

	opts.desc = "Markdown"
	map({ "n", "x" }, "<cr>", "<cmd>MDTaskToggle<cr>", opts)
	map("i", "<c-cr>", "<cmd>MDListItemBelow<cr>", opts)
	map("i", "<s-cr>", "<cmd>MDListItemAbove<cr>", opts)
	map("x", "<c-b>", toggle("b"), opts)
	map("x", "<c-i>", toggle("i"), opts)

	opts.desc = "Preview equation"
	map("n", "<localleader>p", require("nabla").popup, opts)

	wk.register({ ["<leader>z"] = {
		name = "zotero",
		buffer = event.buf,
	} })

	opts.desc = "Citation complete info"
	map("n", "<leader>zc", "<Plug>ZCitationCompleteInfo", opts)

	opts.desc = "Citation info"
	map("n", "<leader>zi", "<Plug>ZCitationInfo", opts)

	opts.desc = "Open attachment"
	map("n", "<leader>zo", "<Plug>ZOpenAttachment", opts)

	opts.desc = "View document"
	map("n", "<leader>zv", "<Plug>ZViewDocument", opts)

	opts.desc = "YAML reference"
	map("n", "<leader>zy", "<Plug>ZCitationYamlRef", opts)

	opts.desc = "Add Zotero reference to local .bib file"
	map("n", "<leader>zz", "<cmd>Telescope zotero<cr>", opts)
end

keybindings.ft = {
	lua = function(event)
		keybindings.refactor(event)
	end,
	go = function(event)
		keybindings.dap(event)
		keybindings.refactor(event)

		local opts = { noremap = true, buffer = event.buf }

		opts.desc = "Debug test"
		map("n", "<leader>dt", require("dap-go").debug_test, opts)

		opts.desc = "Debug last test"
		map("n", "<leader>dT", require("dap-go").debug_last_test, opts)

		wk.register({ ["<leader>g"] = {
			name = "go",
			buffer = event.buf,
		} })

		opts.desc = "Add json struct tags"
		map("n", "<localleader>gj", "<cmd>GoTagAdd json<cr>", opts)

		opts.desc = "Add yaml struct tags"
		map("n", "<localleader>gy", "<cmd>GoTagAdd yaml<cr>", opts)
	end,
	markdown = function(event)
		keybindings.writing(event)
	end,
	python = function(event)
		keybindings.dap(event)
		keybindings.refactor(event)

		local opts = { noremap = true, buffer = event.buf }

		opts.desc = "Debug function/method"
		map("n", "<leader>df", require("dap-python").test_method, opts)

		opts.desc = "Debug class"
		map("n", "<leader>dc", require("dap-python").test_class, opts)

		opts.desc = "Debug selection"
		map("x", "<leader>ds", require("dap-python").debug_selection, opts)
	end,
	quarto = function(event)
		keybindings.writing(event)
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
