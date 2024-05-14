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

		opts.desc = "Exit terminal mode"
		map("t", "<c-c>", "<c-\\><c-n>", opts)

		opts.desc = "Replay macro"
		map("n", "Q", "@q", opts)

		opts.desc = "Replay macro (visual)"
		map("v", "Q", "<cmd>norm @q<cr>", opts)

		opts.desc = "Split (H)"
		map("n", "<leader>-", "<cmd>split<cr>", opts)

		opts.desc = "Split (V)"
		map("n", "<leader>\\", "<cmd>vsplit<cr>", opts)

		opts.desc = "Resize and make windows equal"
		map("n", "<leader>=", "<c-w>=", opts)

		opts.desc = "Commands"
		map("n", "<leader>.", "<cmd>Telescope commands<cr>", opts)

		opts.desc = "Help"
		map("n", "<leader>?", "<cmd>Telescope help_tags<cr>", opts)

		opts.desc = "Keymaps"
		map("n", "<leader>K", "<cmd>Telescope keymaps<cr>", opts)

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
		map("n", "<leader>Z", "<cmd>ZenMode<cr>", opts)
	end,
	better_keys = function()
		local opts = { expr = true, noremap = true, silent = true, desc = "Better keys" }

		map("n", "N", [[v:searchforward ? 'N' : 'n']], opts)
		map("n", "n", [[v:searchforward ? 'n' : 'N']], opts)
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
	copilot = function()
		local opts = { noremap = true }

		wk.register({ ["<leader>c"] = { name = "copilot" } })

		opts.desc = "Toggle chat"
		map("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", opts)

		opts.desc = "Reset chat"
		map("n", "<leader>cr", "<cmd>CopilotChatReset<cr>", opts)

		opts.desc = "Add documentation"
		map({ "n", "v" }, "<leader>cd", "<cmd>CopilotChatDocs<cr>", opts)

		opts.desc = "Explain code"
		map({ "n", "v" }, "<leader>ce", "<cmd>CopilotChatExplain<cr>", opts)

		opts.desc = "Fix code"
		map({ "n", "v" }, "<leader>cf", "<cmd>CopilotChatFix<cr>", opts)

		opts.desc = "Optimize code"
		map({ "n", "v" }, "<leader>co", "<cmd>CopilotChatOptimize<cr>", opts)

		opts.desc = "Generate tests"
		map({ "n", "v" }, "<leader>ct", "<cmd>CopilotChatTests<cr>", opts)
	end,
	executor = function()
		local opts = { noremap = true }

		wk.register({ ["<leader>r"] = { name = "runner" } })

		opts.desc = "Run command"
		map("n", "<leader>rr", require("executor").commands.run, opts)

		opts.desc = "Details"
		map("n", "<leader>rt", require("executor").commands.toggle_detail, opts)

		opts.desc = "Set command"
		map("n", "<leader>rs", require("executor").commands.set_command, opts)
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

		wk.register({ ["<leader>g"] = { name = "git" } })

		opts.desc = "Branches"
		map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", opts)

		opts.desc = "Commits (current file)"
		map("n", "<leader>gc", "<cmd>Telescope git_bcommits<cr>", opts)

		opts.desc = "Commits (cwd)"
		map("n", "<leader>gC", "<cmd>Telescope git_commits<cr>", opts)

		opts.desc = "Diff"
		map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", opts)

		opts.desc = "LazyGit (current file)"
		map("n", "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", opts)

		opts.desc = "LazyGit (cwd)"
		map("n", "<leader>gG", "<cmd>LazyGit<cr>", opts)

		opts.desc = "Files"
		map("n", "<leader>gf", "<cmd>Telescope git_files<cr>", opts)

		opts.desc = "Status"
		map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", opts)

		opts.desc = "Stash"
		map("n", "<leader>gt", "<cmd>Telescope git_stash<cr>", opts)
	end,
	obsidian = function()
		local opts = { noremap = true }

		wk.register({ ["<leader>o"] = { name = "obsidian" } })

		opts.desc = "Backlinks"
		map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", opts)

		opts.desc = "Create note"
		map("n", "<leader>oc", "<cmd>ObsidianNew<cr>", opts)

		opts.desc = "Extract to new note"
		map("v", "<leader>oe", "<cmd>ObsidianExtractNote<cr>", opts)

		opts.desc = "Add link"
		map("v", "<leader>ol", "<cmd>ObsidianLink<cr>", opts)

		opts.desc = "Add link to new file"
		map("v", "<leader>on", "<cmd>ObsidianLinkNew<cr>", opts)

		opts.desc = "Search notes"
		map("n", "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", opts)

		opts.desc = "Paste image"
		map("n", "<leader>op", "<cmd>ObsidianPasteImg<cr>", opts)

		opts.desc = "Rename note"
		map("n", "<leader>or", "<cmd>ObsidianRename<cr>", opts)

		opts.desc = "Search in notes"
		map("n", "<leader>os", "<cmd>ObsidianSearch<cr>", opts)

		opts.desc = "Tags"
		map("n", "<leader>ot", "<cmd>ObsidianTags<cr>", opts)
	end,
	slime = function()
		local opts = { noremap = true, silent = true }

		opts.desc = "Send to REPL"
		map({ "n", "v" }, "<s-cr>", "<Plug>SlimeParagraphSend", opts)

		opts.desc = "Config SLIME"
		map({ "n", "v" }, ",,", "<Plug>SlimeConfig", opts)
	end,
	smart_splits = function()
		local opts = { silent = true, desc = "Smart splits" }

		map("n", "<a-h>", require("smart-splits").swap_buf_left, opts)
		map("n", "<a-j>", require("smart-splits").swap_buf_down, opts)
		map("n", "<a-k>", require("smart-splits").swap_buf_up, opts)
		map("n", "<a-l>", require("smart-splits").swap_buf_right, opts)
		map("n", "<c-h>", require("smart-splits").move_cursor_left, opts)
		map("n", "<c-j>", require("smart-splits").move_cursor_down, opts)
		map("n", "<c-k>", require("smart-splits").move_cursor_up, opts)
		map("n", "<c-l>", require("smart-splits").move_cursor_right, opts)
		map("n", "<c-left>", require("smart-splits").resize_left, opts)
		map("n", "<c-down>", require("smart-splits").resize_down, opts)
		map("n", "<c-up>", require("smart-splits").resize_up, opts)
		map("n", "<c-right>", require("smart-splits").resize_right, opts)
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
		map("n", "<leader><tab>d", "<cmd>tabclose<cr>", opts)

		opts.desc = "First tab"
		map("n", "<leader><tab>g", "<cmd>tabfirst<cr>", opts)

		opts.desc = "Keep only this tab"
		map("n", "<leader><tab>k", "<cmd>tabonly<cr>", opts)

		opts.desc = "New tab"
		map("n", "<leader><tab>n", "<cmd>tabnew<cr>", opts)
	end,
}

keybindings.lsp = function(event)
	local opts = { noremap = true, buffer = event.buf }
	local client = vim.lsp.get_client_by_id(event.data.client_id)

	opts.desc = "LSP: rename"
	map("n", "<F2>", vim.lsp.buf.rename, opts)

	opts.desc = "LSP: go to declaration"
	map("n", "gD", vim.lsp.buf.declaration, opts)

	opts.desc = "LSP: go to references"
	map("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)

	opts.desc = "LSP: go to definition"
	map("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)

	opts.desc = "LSP: go to type definition"
	map("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)

	opts.desc = "LSP: go to implementations"
	map("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)

	opts.desc = "LSP: code actions"
	map({ "n", "v" }, "<leader>a", require("actions-preview").code_actions, opts)

	opts.desc = "LSP: symbols (document)"
	map("n", "<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", opts)

	opts.desc = "LSP: symbols (workspace)"
	map("n", "<leader>S", "<cmd>Telescope lsp_workspace_symbols<cr>", opts)

	opts.desc = "LSP: diagnostics"
	map("n", "<leader>d", "<cmd>Telescope diagnostics<cr>", opts)

	opts.desc = "LSP: floating diagnostics"
	map("n", "<leader>F", vim.diagnostic.open_float, opts)

	opts.desc = "LSP: signature help"
	map("n", "<leader>h", require("lsp_signature").toggle_float_win, opts)

	opts.desc = "LSP: hover"
	map("n", "<leader>k", vim.lsp.buf.hover, opts)

	if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		opts.desc = "LSP: inlay hints"
		map("n", "<leader>i", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, opts)
	end
end

keybindings.dap = function(event)
	local opts = { noremap = true, buffer = event.buf }

	wk.register({ ["<leader>t"] = {
		name = "DAP",
		buffer = event.buf,
		mode = { "n", "v" },
	} })

	opts.desc = "DAP: step into"
	map("n", "<f1>", require("dap").step_into, opts)

	opts.desc = "DAP: step out"
	map("n", "<f3>", require("dap").step_out, opts)

	opts.desc = "DAP: step back"
	map("n", "<f5>", require("dap").step_back, opts)

	opts.desc = "DAP: continue"
	map("n", "<f6>", require("dap").continue, opts)

	opts.desc = "DAP: step over"
	map("n", "<f7>", require("dap").step_over, opts)

	opts.desc = "DAP: pause"
	map("n", "<s-f6>", require("dap").pause, opts)

	opts.desc = "DAP: terminate"
	map("n", "<bs>", function()
		require("dap").terminate()
		require("dapui").close()
	end, opts)

	opts.desc = "Breakpoint"
	map("n", "<leader>tb", require("dap").toggle_breakpoint, opts)

	opts.desc = "Clear all breakpoints"
	map("n", "<leader>tc", require("dap").clear_breakpoints, opts)

	opts.desc = "Show hover"
	map("n", "<leader>tk", require("dap.ui.widgets").hover, opts)

	opts.desc = "List breakpoints"
	map("n", "<leader>tl", "<cmd>Telescope dap list_breakpoints<cr>", opts)

	opts.desc = "Toggle REPL"
	map("n", "<leader>tr", require("dap").repl.toggle, opts)

	opts.desc = "Toggle UI"
	map("n", "<leader>tu", require("dapui").toggle, opts)

	opts.desc = "Conditional breakpoint"
	map("n", "<leader>tB", function()
		require("dap").set_breakpoint(vim.fn.input("Condition: "))
	end, opts)
end

keybindings.ft = {
	go = function(event)
		local opts = { noremap = true, buffer = event.buf }

		keybindings.dap(event)

		opts.desc = "Go: debug test"
		map("n", "<leader>tt", require("dap-go").debug_test, opts)

		opts.desc = "Go: debug latest test"
		map("n", "<leader>tT", require("dap-go").debug_last_test, opts)
	end,
	markdown = function(event)
		local opts = { noremap = true, buffer = event.buf }

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
	end,
	python = function(event)
		local opts = { noremap = true, buffer = event.buf }

		keybindings.dap(event)

		opts.desc = "Python: test function/method"
		map("n", "<leader>tf", require("dap-python").test_method, opts)

		opts.desc = "Python: test class"
		map("n", "<leader>tc", require("dap-python").test_class, opts)

		opts.desc = "Python: debug selection"
		map("v", "<leader>ts", require("dap-python").debug_selection, opts)
	end,
	quarto = function(event)
		local opts = { noremap = true, buffer = event.buf }

		opts.desc = "Add source from Zotero"
		map("n", "<leader>z", "<cmd>Telescope zotero<cr>", opts)
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
