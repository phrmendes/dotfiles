local wk = require("which-key")
local augroup = require("utils").augroup
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

vim.g.VM_maps = {
	["Add Cursor Down"] = "m",
	["Add Cursor Up"] = "M",
}

map("n", "<a-h>", require("smart-splits").swap_buf_left, { desc = "Swap buffer left" })
map("n", "<a-j>", require("smart-splits").swap_buf_down, { desc = "Swap buffer down" })
map("n", "<a-k>", require("smart-splits").swap_buf_up, { desc = "Swap buffer up" })
map("n", "<a-l>", require("smart-splits").swap_buf_right, { desc = "Swap buffer right" })
map("n", "<c-down>", require("smart-splits").resize_down, { desc = "Resize down" })
map("n", "<c-left>", require("smart-splits").resize_left, { desc = "Resize left" })
map("n", "<c-right>", require("smart-splits").resize_right, { desc = "Resize right" })
map("n", "<c-up>", require("smart-splits").resize_up, { desc = "Resize up" })
map("n", "<c-d>", "<c-d>zz", { noremap = true, silent = true, desc = "Better page down" })
map("n", "<c-h>", require("smart-splits").move_cursor_left, { desc = "Move cursor left" })
map("n", "<c-j>", require("smart-splits").move_cursor_down, { desc = "Move cursor down" })
map("n", "<c-k>", require("smart-splits").move_cursor_up, { desc = "Move cursor up" })
map("n", "<c-l>", require("smart-splits").move_cursor_right, { desc = "Move cursor right" })
map("n", "<c-u>", "<c-u>zz", { noremap = true, silent = true, desc = "Better page up" })
map("n", "<esc>", "<cmd>nohlsearch<cr>", { noremap = true, silent = true })
map("n", "Q", "@q", { noremap = true, silent = true })
map("n", "N", [[v:searchforward ? 'N' : 'n']], { expr = true, noremap = true, silent = true })
map("n", "n", [[v:searchforward ? 'n' : 'N']], { expr = true, noremap = true, silent = true })
map("n", "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, noremap = true, silent = true })
map("n", "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, noremap = true, silent = true })
map("t", "<c-c>", "<c-\\><c-n>", { noremap = true, silent = true })
map("v", "Q", "<cmd>norm @q<cr>", { noremap = true, silent = true })
map({ "n", "v" }, "<c-c><c-c>", "<Plug>SlimeParagraphSend", { noremap = true, silent = true, desc = "Send to REPL" })
map({ "n", "v" }, "<c-c><c-v>", "<Plug>SlimeConfig", { noremap = true, silent = true, desc = "Config Slime" })

wk.register({
	["<tab>"] = { mode = "n", name = "tabs" },
	b = { mode = "n", name = "buffers" },
	f = { mode = "n", name = "find" },
	t = { mode = "n", name = "trouble" },
	z = { mode = "n", name = "zotero" },
	c = { mode = { "n", "v" }, name = "copilot" },
	o = { mode = { "n", "v" }, name = "obsidian" },
	d = {
		mode = { "n", "v" },
		name = "DAP",
		p = { name = "python" },
	},
	g = {
		mode = { "n", "v" },
		name = "git",
		s = { name = "stage" },
		r = { name = "reset" },
	},
}, { prefix = "<leader>" })

wk.register({
	["["] = {
		["<tab>"] = { "<cmd>tabprevious<cr>", "Previous tab" },
		h = { require("gitsigns").prev_hunk, "Previous hunk" },
		t = { require("todo-comments").jump_prev, "Previous todo" },
	},
	["]"] = {
		["<tab>"] = { "<cmd>tabnext<cr>", "Next tab" },
		h = { require("gitsigns").next_hunk, "Next hunk" },
		t = { require("todo-comments").jump_next, "Next todo" },
	},
	["<leader>"] = {
		["-"] = { "<cmd>split<cr>", "Split window (H)" },
		["."] = { "<cmd>Telescope commands<cr>", "Commands" },
		["="] = { "<c-w>=", "Resize and make windows equal" },
		["?"] = { "<cmd>Telescope help_tags<cr>", "Help" },
		["\\"] = { "<cmd>vsplit<cr>", "Split window (V)" },
		["_"] = { "<c-w>_", "Maximize (H)" },
		["|"] = { "<c-w>|", "Maximize (V)" },
		E = { "<cmd>NvimTreeToggle<cr>", "File explorer (cwd)" },
		O = { "<c-w>o", "Keep only current window" },
		Q = { "<cmd>qall!<cr>", "Quit all" },
		Z = { "<cmd>ZenMode<cr>", "Zen mode" },
		e = { "<cmd>NvimTreeFindFileToggle<cr>", "File explorer (current file)" },
		n = { "<cmd>Neogen<cr>", "Generate annotations" },
		q = { "<cmd>q<cr>", "Quit" },
		u = { "<cmd>UndotreeToggle<cr>", "Undo tree" },
		w = { "<cmd>w<cr>", "Save" },
		x = { "<c-w>q", "Close window" },
	},
	["<leader><tab>"] = {
		["<tab>"] = { "<cmd>tab split<cr>", "Open in new tab" },
		G = { "<cmd>tablast<cr>", "Last tab" },
		d = { "<cmd>tabclose<cr>", "Close tab" },
		g = { "<cmd>tabfirst<cr>", "First tab" },
		k = { "<cmd>tabonly<cr>", "Keep only this tab" },
		n = { "<cmd>tabnew<cr>", "New tab" },
	},
	["<leader>b"] = {
		G = { "<cmd>blast<cr>", "Go to last buffer" },
		b = { "<cmd>Telescope buffers<cr>", "List" },
		d = { require("mini.bufremove").delete, "Delete" },
		f = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search in current buffer" },
		g = { "<cmd>bfirst<cr>", "Go to last buffer" },
		k = { "<cmd>%bdelete<bar>edit#<bar>bdelete#<cr>", "Keep only this buffer" },
		w = { require("mini.bufremove").wipeout, "Wipeout" },
	},
	["<leader>c"] = {
		c = { "<cmd>CopilotChatToggle<cr>", "Open" },
		r = { "<cmd>CopilotChatReset<cr>", "Reset" },
		d = { mode = "v", "<cmd>CopilotChatDocs<cr>", "Add documentation" },
		e = { mode = "v", "<cmd>CopilotChatExplain<cr>", "Explain code" },
		f = { mode = "v", "<cmd>CopilotChatFix<cr>", "Fix code" },
		o = { mode = "v", "<cmd>CopilotChatOptimize<cr>", "Optimize code" },
		t = { mode = "v", "<cmd>CopilotChatTests<cr>", "Generate tests" },
	},
	["<leader>f"] = {
		f = { "<cmd>Telescope find_files<cr>", "Files" },
		g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
		o = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
		r = { require("spectre").toggle, "Replace" },
		t = { "<cmd>TodoTelescope<cr>", "Todo" },
		z = { "<cmd>Telescope zoxide list<cr>", "Zoxide" },
	},
	["<leader>g"] = {
		B = { require("gitsigns").toggle_current_line_blame, "Blame line" },
		C = { "<cmd>Telescope git_commits<cr>", "Commits (cwd)" },
		G = { "<cmd>LazyGit<cr>", "LazyGit" },
		b = { "<cmd>Telescope git_branches<cr>", "Checkout" },
		c = { "<cmd>Telescope git_bcommits<cr>", "Commits (current file)" },
		d = { require("gitsigns").diffthis, "Diff" },
		f = { "<cmd>Telescope git_files<cr>", "Files" },
		g = { "<cmd>LazyGitCurrentFile<cr>", "LazyGit (current file)" },
		s = {
			h = { mode = { "n", "v" }, require("gitsigns").stage_hunk, "Hunk" },
			b = { require("gitsigns").stage_buffer, "Buffer" },
		},
		r = {
			h = { mode = { "n", "v" }, require("gitsigns").reset_hunk, "Hunk" },
			b = { require("gitsigns").reset_buffer, "Buffer" },
		},
	},
	["<leader>o"] = {
		b = { "<cmd>ObsidianBacklinks<cr>", "Backlinks" },
		c = { "<cmd>ObsidianNew<cr>", "Create note" },
		e = { mode = "v", "<cmd>ObsidianExtractNote<cr>", "Extract to new note" },
		l = { mode = "v", "<cmd>ObsidianLink<cr>", "Add link" },
		n = { mode = "v", "<cmd>ObsidianLinkNew<cr>", "Add link to new file" },
		o = { "<cmd>ObsidianQuickSwitch<cr>", "Search notes" },
		p = { "<cmd>ObsidianPasteImg<cr>", "Paste image" },
		r = { "<cmd>ObsidianRename<cr>", "Rename note" },
		s = { "<cmd>ObsidianSearch<cr>", "Search in notes" },
		t = { "<cmd>ObsidianTags<cr>", "Tags" },
	},
	["<leader>t"] = {
		T = { "<cmd>TodoTrouble", "Todo" },
		r = { "<cmd>TroubleRefresh<cr>", "Refresh" },
		t = { "<cmd>TroubleToggle<cr>", "Toggle" },
	},
})

autocmd("FileType", {
	group = augroup,
	pattern = "markdown",
	callback = function(ev)
		wk.register({
			["<leader>z"] = {
				c = { "<Plug>ZCitationCompleteInfo", "Citation complete info" },
				i = { "<Plug>ZCitationInfo", "Citation info" },
				o = { "<Plug>ZOpenAttachment", "Open attachment" },
				v = { "<Plug>ZViewDocument", "View document" },
				y = { "<Plug>ZCitationYamlRef", "YAML reference" },
			},
		}, { buffer = ev.buf })
	end,
})

autocmd("FileType", {
	group = augroup,
	pattern = "quarto",
	callback = function(ev)
		wk.register({
			["<leader>z"] = {
				z = { "<cmd>Telescope zotero<cr>", "Add source from Zotero" },
			},
		}, { buffer = ev.buf })
	end,
})

autocmd("FileType", {
	group = augroup,
	pattern = "python",
	callback = function(ev)
		wk.register({
			["<leader>dp"] = {
				d = { require("dap-python").debug_file, "Debug file" },
				s = { mode = "v", require("dap-python").debug_selection, "Debug selection" },
				t = { require("dap-python").test_file, "Test file" },
			},
		}, { buffer = ev.buf })
	end,
})

autocmd("LspAttach", {
	group = augroup,
	callback = function(ev)
		wk.register({
			["<F3>"] = { require("dap").step_out, "DAP: step out" },
			["<F4>"] = { require("dap").step_into, "DAP: step into" },
			["<F5>"] = { require("dap").step_back, "DAP: step back" },
			["<F6>"] = { require("dap").continue, "DAP: continue" },
			["<F7>"] = { require("dap").step_over, "DAP: step over" },
			["<S-F6>"] = { require("dap").pause, "DAP: pause" },
			["<bs>"] = { require("dap").close, "DAP: quit" },
			g = {
				D = { vim.lsp.buf.declaration, "Go to declaration" },
				d = { "<cmd>Trouble lsp_definitions<cr>", "Go to definition" },
				i = { "<cmd>Trouble lsp_implementations<cr>", "Go to implementations" },
				t = { "<cmd>Trouble lsp_type_definitions<cr>", "Go to type definition" },
			},
			["<leader>"] = {
				F = { vim.diagnostic.open_float, "Floating diagnostics" },
				R = { "<cmd>Trouble lsp_references<cr>", "Show references" },
				S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace symbols" },
				a = { mode = { "n", "v" }, require("actions-preview").code_actions, "Code actions" },
				h = { require("lsp_signature").toggle_float_win, "Toggle signature help" },
				k = { vim.lsp.buf.hover, "Show hover" },
				r = { vim.lsp.buf.rename, "Rename symbol" },
				s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
				t = {
					name = "trouble",
					d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document diagnostics" },
					w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace diagnostics" },
				},
				d = {
					b = { require("dap").toggle_breakpoint, "Breakpoint" },
					c = { require("dap").clear_breakpoints, "Clear all breakpoints" },
					k = { require("dap.ui.widgets").hover, "Show hover" },
					l = { "<cmd>Telescope dap list_breakpoints<cr>", "List breakpoints" },
					r = { require("dap").repl.toggle, "Toggle REPL" },
					u = { require("dapui").toggle, "Toggle UI" },
					q = {
						function()
							require("dap").terminate()
							require("dapui").close()
						end,
						"Terminate",
					},
					B = {
						function()
							require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
						end,
						"Conditional breakpoint",
					},
				},
			},
		}, { buffer = ev.buf })
	end,
})
