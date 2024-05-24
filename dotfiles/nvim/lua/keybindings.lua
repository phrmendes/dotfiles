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

		opts.desc = "Keymaps"
		map("n", "<leader>k", "<cmd>Telescope keymaps<cr>", opts)

		opts.desc = "Generate annotations"
		map("n", "<leader>n", "<cmd>Neogen<cr>", opts)

		opts.desc = "Quit"
		map("n", "<leader>q", "<cmd>q<cr>", opts)

		opts.desc = "Quit all"
		map("n", "<leader>Q", "<cmd>qall!<cr>", opts)

		opts.desc = "Undo tree"
		map("n", "<leader>u", "<cmd>UndotreeToggle<cr>", opts)

		opts.desc = "Save"
		map("n", "<leader>w", "<cmd>w<cr>", opts)

		opts.desc = "Save all"
		map("n", "<leader>W", "<cmd>wall!<cr>", opts)

		opts.desc = "Close window"
		map("n", "<leader>x", "<c-w>q", opts)

		opts.desc = "Close all other windows"
		map("n", "<leader>X", "<c-w>o", opts)

		opts.desc = "Zen mode"
		map("n", "<leader>z", "<cmd>ZenMode<cr>", opts)
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

		opts.desc = "List buffers"
		map("n", "<leader><leader>", "<cmd>Telescope buffers<cr>", opts)

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
			explorer(vim.uv.cwd())
		end, opts)
	end,
	find = function()
		local opts = { noremap = true }

		wk.register({ ["<leader>f"] = { name = "find" } })

		opts.desc = "Find in buffer"
		map("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)

		opts.desc = "Files"
		map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)

		opts.desc = "Live grep"
		map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)

		opts.desc = "Recent"
		map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", opts)

		opts.desc = "TODO"
		map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", opts)

		opts.desc = "Zoxide"
		map("n", "<leader>fz", "<cmd>Telescope zoxide list<cr>", opts)
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
	obsidian = function()
		local opts = { noremap = true }

		wk.register({ ["<leader>o"] = {
			name = "obsidian",
			mode = { "n", "x" },
		} })

		opts.desc = "Backlinks"
		map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", opts)

		opts.desc = "Create note"
		map("n", "<leader>oc", "<cmd>ObsidianNew<cr>", opts)

		opts.desc = "Extract to new note"
		map("x", "<leader>oe", "<cmd>ObsidianExtractNote<cr>", opts)

		opts.desc = "Add link"
		map("x", "<leader>oa", "<cmd>ObsidianLink<cr>", opts)

		opts.desc = "Add link to new file"
		map("x", "<leader>on", "<cmd>ObsidianLinkNew<cr>", opts)

		opts.desc = "Search notes"
		map("n", "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", opts)

		opts.desc = "Paste image"
		map("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", opts)

		opts.desc = "Rename note"
		map("n", "<leader>or", "<cmd>ObsidianRename<cr>", opts)

		opts.desc = "Live grep (notes)"
		map("n", "<leader>og", "<cmd>ObsidianSearch<cr>", opts)

		opts.desc = "Tags"
		map("n", "<leader>ot", "<cmd>ObsidianTags<cr>", opts)
	end,
	rest = function()
		local opts = { noremap = true }
		wk.register({ ["<leader>h"] = { name = "http client" } })

		opts.desc = "Run request under cursor"
		map("n", "<leader>hr", "<cmd>Rest run<cr>", opts)

		opts.desc = "Re-run last request"
		map("n", "<leader>hl", "<cmd>Rest run last<cr>", opts)

		opts.desc = "Select env"
		map("n", "<leader>hs", "<cmd>Telescope rest select_env<cr>", opts)
	end,
	refactor = function()
		local opts = { noremap = true }

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
		vim.keymap.set({ "n", "x" }, "<leader>rr", function()
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
	end,
	sniprun = function()
		local opts = { noremap = true, silent = true }

		opts.desc = "SnipRun"
		map("n", "<localleader>r", "<Plug>SnipRunOperator", opts)
		map("n", "<localleader>rr", "<Plug>SnipRun", opts)
		map("x", "<localleader>r", "<Plug>SnipRun", opts)

		opts.desc = "Close SnipRun"
		map("n", "<localleader>q", "<Plug>SnipClose", opts)
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
	session = function()
		local opts = { noremap = true }

		wk.register({ ["<leader>s"] = { name = "sessions" } })

		opts.desc = "Create"
		map("n", "<leader>ss", "<cmd>mksession<cr>", opts)

		opts.desc = "Choose"
		map("n", "<leader>sc", require("mini.sessions").select, opts)
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

		opts.desc = "Put yanked text after cursor"
		map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", opts)

		opts.desc = "Put yanked text before cursor"
		map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", opts)

		opts.desc = "Put yanked text after selection"
		map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", opts)

		opts.desc = "Put yanked text before selection"
		map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", opts)

		opts.desc = "Previous yanked entry"
		map("n", "]y", "<Plug>(YankyPreviousEntry)", opts)

		opts.desc = "Cycle backward through yanked text"
		map("n", "[y", "<Plug>(YankyNextEntry)", opts)

		opts.desc = "Put yanked text after cursor (linewise)"
		map("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", opts)
		map("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", opts)

		opts.desc = "Put yanked text before cursor (linewise)"
		map("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", opts)
		map("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", opts)

		opts.desc = "Put yanked text after cursor and indent right"
		map("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)", opts)

		opts.desc = "Put yanked text after cursor and indent left"
		map("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", opts)

		opts.desc = "Put yanked text before cursor and indent right"
		map("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", opts)

		opts.desc = "Put yanked text before cursor and indent left"
		map("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", opts)

		opts.desc = "Put yanked text after applying a filer"
		map("n", "=p", "<Plug>(YankyPutAfterFilter)", opts)

		opts.desc = "Put yanked text before applying a filer"
		map("n", "=P", "<Plug>(YankyPutBeforeFilter)", opts)
	end,
}

keybindings.lsp = function(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	local opts = { noremap = true, buffer = event.buf }

	wk.register({ ["<leader>c"] = {
		name = "code",
		buffer = event.buf,
		mode = { "n", "x" },
	} })

	opts.desc = "Rename"
	map("n", "<F2>", vim.lsp.buf.rename, opts)

	opts.desc = "Go to declaration"
	map("n", "gD", vim.lsp.buf.declaration, opts)

	opts.desc = "Go to references"
	map("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)

	opts.desc = "Go to definition"
	map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)

	opts.desc = "Go to type definition"
	map("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)

	opts.desc = "Go to implementations"
	map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)

	opts.desc = "Signature help"
	map("n", "gK", require("lsp_signature").toggle_float_win, opts)

	opts.desc = "Actions"
	map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, opts)

	opts.desc = "Info"
	map("n", "<leader>ci", "<cmd>LspInfo<cr>", opts)

	opts.desc = "Symbols (document)"
	map("n", "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", opts)

	opts.desc = "Symbols (workspace)"
	map("n", "<leader>cS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", opts)

	opts.desc = "Diagnostics"
	map("n", "<leader>cd", "<cmd>Telescope diagnostics<cr>", opts)

	opts.desc = "Floating diagnostics"
	map("n", "<leader>cf", vim.diagnostic.open_float, opts)

	opts.desc = "Hover"
	map("n", "<leader>ck", vim.lsp.buf.hover, opts)

	if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		opts.desc = "Inlay hints"
		map("n", "<leader>ch", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, opts)
	end
end

keybindings.dap = function(event)
	local opts = { noremap = true, buffer = event.buf }

	wk.register({ ["<leader>d"] = {
		name = "debugger",
		buffer = event.buf,
		mode = { "n", "x" },
	} })

	opts.desc = "Step into"
	map("n", "<f1>", require("dap").step_into, opts)

	opts.desc = "Step out"
	map("n", "<f3>", require("dap").step_out, opts)

	opts.desc = "Step back"
	map("n", "<f5>", require("dap").step_back, opts)

	opts.desc = "Continue"
	map("n", "<f6>", require("dap").continue, opts)

	opts.desc = "Step over"
	map("n", "<f7>", require("dap").step_over, opts)

	opts.desc = "Pause"
	map("n", "<s-f6>", require("dap").pause, opts)

	opts.desc = "Terminate"
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

keybindings.tests = function(event)
	local opts = { noremap = true, buffer = event.buf }

	wk.register({ ["<leader>t"] = {
		name = "tests",
		buffer = event.buf,
	} })

	opts.desc = "Previous failed test"
	map("n", "[n", function()
		require("neotest").jump.prev({ status = "failed" })
	end, opts)

	opts.desc = "Next failed test"
	map("n", "]n", function()
		require("neotest").jump.next({ status = "failed" })
	end, opts)

	opts.desc = "Attach"
	map("n", "<leader>ta", require("neotest").run.attach, opts)

	opts.desc = "Debug (nearest)"
	map("n", "<leader>td", function()
		require("neotest").run.run({ suite = false, strategy = "dap" })
	end, opts)

	opts.desc = "Output (panel)"
	map("n", "<leader>tp", require("neotest").output_panel.toggle, opts)

	opts.desc = "Output"
	map("n", "<leader>to", function()
		require("neotest").output.open({ enter = true, auto_close = true })
	end, opts)

	opts.desc = "Stop"
	map("n", "<leader>tq", require("neotest").run.stop, opts)

	opts.desc = "Summary"
	map("n", "<leader>ts", require("neotest").summary.toggle, opts)

	opts.desc = "Test (nearest)"
	map("n", "<leader>tt", require("neotest").run.run, opts)

	opts.desc = "Test (last)"
	map("n", "<leader>tl", require("neotest").run.run_last, opts)

	opts.desc = "Test (suite)"
	map("n", "<leader>ts", function()
		require("neotest").run.run({ suite = false })
	end, opts)

	opts.desc = "Test (current file)"
	map("n", "<leader>tf", function()
		require("neotest").run.run(vim.fn.expand("%"))
	end, opts)

	opts.desc = "Test (cwd)"
	map("n", "<leader>tw", function()
		require("neotest").run.run(vim.uv.cwd())
	end, opts)
end

keybindings.ft = {
	go = function(event)
		local opts = { noremap = true, buffer = event.buf }

		keybindings.dap(event)
		keybindings.tests(event)

		opts.desc = "Go: debug test"
		map("n", "<leader>dt", require("dap-go").debug_test, opts)

		opts.desc = "Go: debug last test"
		map("n", "<leader>dT", require("dap-go").debug_last_test, opts)

		opts.desc = "Go: add json struct tags"
		map("n", "<localleader>j", "<cmd>GoTagAdd json<cr>", opts)

		opts.desc = "Go: add yaml struct tags"
		map("n", "<localleader>y", "<cmd>GoTagAdd yaml<cr>", opts)
	end,
	markdown = function(event)
		local opts = { noremap = true, buffer = event.buf }

		wk.register({ ["<localleader>z"] = {
			name = "zotero",
			buffer = event.buf,
		} })

		opts.desc = "Citation complete info"
		map("n", "<localleader>zc", "<Plug>ZCitationCompleteInfo", opts)

		opts.desc = "Citation info"
		map("n", "<localleader>zi", "<Plug>ZCitationInfo", opts)

		opts.desc = "Open attachment"
		map("n", "<localleader>zo", "<Plug>ZOpenAttachment", opts)

		opts.desc = "View document"
		map("n", "<localleader>zv", "<Plug>ZViewDocument", opts)

		opts.desc = "YAML reference"
		map("n", "<localleader>zy", "<Plug>ZCitationYamlRef", opts)
	end,
	python = function(event)
		local opts = { noremap = true, buffer = event.buf }

		keybindings.dap(event)
		keybindings.tests(event)

		opts.desc = "Python: debug function/method"
		map("n", "<leader>df", require("dap-python").test_method, opts)

		opts.desc = "Python: debug class"
		map("n", "<leader>dc", require("dap-python").test_class, opts)

		opts.desc = "Python: debug selection"
		map("x", "<leader>ds", require("dap-python").debug_selection, opts)
	end,
	quarto = function(event)
		local opts = { noremap = true, buffer = event.buf }

		opts.desc = "Add source from Zotero"
		map("n", "<localleader>z", "<cmd>Telescope zotero<cr>", opts)
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
