local wk = require("which-key")
local augroup = require("utils").augroup
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set

vim.g.copilot_no_tab_map = true

vim.g.VM_maps = {
	["Add Cursor Up"] = "M",
	["Add Cursor Down"] = "m",
	["Undo"] = "u",
	["Redo"] = "<C-r>",
}

map("n", "<Esc>", "<CMD>nohlsearch<CR>", { noremap = true, silent = true })
map("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "Better page down" })
map("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "Better page up" })
map("n", "N", [[v:searchforward ? 'N' : 'n']], { expr = true, noremap = true, silent = true })
map("n", "n", [[v:searchforward ? 'n' : 'N']], { expr = true, noremap = true, silent = true })
map("n", "Q", "@q", { noremap = true, silent = true })
map("n", "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, noremap = true, silent = true })
map("n", "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, noremap = true, silent = true })
map("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move cursor left" })
map("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move cursor down" })
map("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move cursor up" })
map("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move cursor right" })
map("n", "<C-Left>", require("smart-splits").resize_left, { desc = "Resize left" })
map("n", "<C-Down>", require("smart-splits").resize_down, { desc = "Resize down" })
map("n", "<C-Up>", require("smart-splits").resize_up, { desc = "Resize up" })
map("n", "<C-Right>", require("smart-splits").resize_right, { desc = "Resize right" })
map("i", "<C-a>", [[copilot#Accept("\\<CR>")]], { expr = true, replace_keycodes = false })
map("t", "<C-c>", "<C-\\><C-n>", { noremap = true, silent = true })
map("v", "Q", "<CMD>norm @q<CR>", { noremap = true, silent = true })
map({ "n", "v" }, "<C-c><C-c>", "<Plug>SlimeParagraphSend", { noremap = true, silent = true, desc = "Send to REPL" })
map({ "n", "v" }, "<C-c><C-v>", "<Plug>SlimeConfig", { noremap = true, silent = true, desc = "Config Slime" })

wk.register({
	["["] = {
		name = "previous",
		["<TAB>"] = { "<CMD>tabprevious<CR>", "Previous tab" },
		h = { require("gitsigns").prev_hunk, "Previous hunk" },
		t = { require("todo-comments").jump_prev, "Previous todo" },
	},
	["]"] = {
		name = "next",
		["<TAB>"] = { "<CMD>tabnext<CR>", "Next tab" },
		h = { require("gitsigns").next_hunk, "Next hunk" },
		t = { require("todo-comments").jump_next, "Next todo" },
	},
	["<leader>"] = {
		["-"] = { "<CMD>split<CR>", "Split window (H)" },
		["."] = { "<CMD>Telescope commands<CR>", "Commands" },
		["="] = { "<C-w>=", "Resize and make windows equal" },
		["?"] = { "<CMD>Telescope help_tags<CR>", "Help" },
		["\\"] = { "<CMD>vsplit<CR>", "Split window (V)" },
		["_"] = { "<C-w>_", "Maximize (H)" },
		["|"] = { "<C-w>|", "Maximize (V)" },
		E = { "<CMD>NvimTreeToggle<CR>", "File explorer (cwd)" },
		O = { "<C-w>o", "Keep only current window" },
		W = { "<CMD>wq<CR>", "Save and quit" },
		e = { "<CMD>NvimTreeFindFileToggle<CR>", "File explorer (current file)" },
		n = { "<CMD>Neogen<CR>", "Generate annotations" },
		q = { "<CMD>q<CR>", "Quit" },
		u = { "<CMD>UndotreeToggle<CR>", "Undo tree" },
		w = { "<CMD>w<CR>", "Save" },
		x = { "<C-w>q", "Close window" },
		z = { "<CMD>ZenMode<CR>", "Zen mode" },
	},
	["<leader><leader>"] = {
		h = { require("smart-splits").swap_buf_left, "Swap buffer left" },
		j = { require("smart-splits").swap_buf_down, "Swap buffer down" },
		k = { require("smart-splits").swap_buf_up, "Swap buffer up" },
		l = { require("smart-splits").swap_buf_right, "Swap buffer right" },
	},
	["<leader><TAB>"] = {
		name = "tabs",
		["<TAB>"] = { "<CMD>tab split<CR>", "Open in new tab" },
		G = { "<CMD>tablast<CR>", "Last tab" },
		d = { "<CMD>tabclose<CR>", "Close tab" },
		g = { "<CMD>tabfirst<CR>", "First tab" },
		k = { "<CMD>tabonly<CR>", "Keep only this tab" },
		n = { "<CMD>tabnew<CR>", "New tab" },
	},
	["<leader>b"] = {
		name = "buffers",
		G = { "<CMD>blast<CR>", "Go to last buffer" },
		b = { "<CMD>Telescope buffers<CR>", "List" },
		d = { require("mini.bufremove").delete, "Delete" },
		f = { "<CMD>Telescope current_buffer_fuzzy_find<CR>", "Search in current buffer" },
		g = { "<CMD>bfirst<CR>", "Go to last buffer" },
		k = { "<CMD>%bdelete<bar>edit#<bar>bdelete#<CR>", "Keep only this buffer" },
		w = { require("mini.bufremove").wipeout, "Wipeout" },
	},
	["<leader>c"] = {
		name = "copilot",
		c = { "<CMD>CopilotChatToggle<CR>", "Open" },
		r = { "<CMD>CopilotChatReset<CR>", "Reset" },
	},
	["<leader>f"] = {
		name = "find",
		f = { "<CMD>Telescope find_files<CR>", "Files" },
		g = { "<CMD>Telescope live_grep<CR>", "Live grep" },
		o = { "<CMD>Telescope oldfiles<CR>", "Recent files" },
		r = { require("spectre").toggle, "Replace" },
		t = { "<CMD>TodoTelescope<CR>", "Todo" },
	},
	["<leader>g"] = {
		name = "git",
		B = { require("gitsigns").toggle_current_line_blame, "Blame line" },
		C = { "<CMD>Telescope git_commits<CR>", "Commits (cwd)" },
		G = { "<CMD>LazyGit<CR>", "LazyGit" },
		b = { "<CMD>Telescope git_branches<CR>", "Checkout" },
		c = { "<CMD>Telescope git_bcommits<CR>", "Commits (current file)" },
		d = { require("gitsigns").diffthis, "Diff" },
		f = { "<CMD>Telescope git_files<CR>", "Files" },
		g = { "<CMD>LazyGitCurrentFile<CR>", "LazyGit (current file)" },
		s = {
			name = "stage",
			h = { require("gitsigns").stage_hunk, "Hunk" },
			b = { require("gitsigns").stage_buffer, "Buffer" },
		},
		r = {
			name = "reset",
			h = { require("gitsigns").reset_hunk, "Hunk" },
			b = { require("gitsigns").reset_buffer, "Buffer" },
		},
	},
})

wk.register({
	["<leader>c"] = {
		name = "copilot",
		d = { "<CMD>CopilotChatDocs<CR>", "Add documentation" },
		e = { "<CMD>CopilotChatExplain<CR>", "Explain code" },
		f = { "<CMD>CopilotChatFix<CR>", "Fix code" },
		o = { "<CMD>CopilotChatOptimize<CR>", "Optimize code" },
		t = { "<CMD>CopilotChatTests<CR>", "Generate tests" },
	},
	["<leader>g"] = {
		name = "git",
		s = {
			name = "stage",
			h = { require("gitsigns").stage_hunk, "Hunk" },
		},
		r = {
			name = "reset",
			h = { require("gitsigns").reset_hunk, "Hunk" },
		},
	},
}, { mode = "v" })

autocmd("FileType", {
	pattern = { "markdown", "quarto" },
	group = augroup,
	callback = function(event)
		wk.register({
			["<leader>Z"] = { "<CMD>Telescope zotero<CR>", "Add source from Zotero" },
		}, { buffer = event.buf })
	end,
})

autocmd("LspAttach", {
	group = augroup,
	callback = function(event)
		wk.register({
			["<F-3>"] = { require("dap").step_out, "DAP: step out" },
			["<F-4>"] = { require("dap").step_into, "DAP: step into" },
			["<F-5>"] = { require("dap").step_back, "DAP: step back" },
			["<F-6>"] = { require("dap").continue, "DAP: continue" },
			["<F-7>"] = { require("dap").step_over, "DAP: step over" },
			["<S-F-6>"] = { require("dap").pause, "DAP: pause" },
			["<BS>"] = { require("dap").close, "DAP: quit" },
			["g"] = {
				D = { vim.lsp.buf.declaration, "Go to declaration" },
				d = { "<CMD>Telescope lsp_definitions<CR>", "Go to definition" },
				i = { "<CMD>Telescope lsp_implementations<CR>", "Go to implementations" },
				t = { "<CMD>Telescope lsp_type_definitions<CR>", "Go to type definition" },
			},
			["<leader>"] = {
				k = { vim.lsp.buf.hover, "Show hover documentation" },
				r = { vim.lsp.buf.rename, "Rename symbol" },
				D = { "<CMD>TroubleToggle workspace_diagnostics<CR>", "Workspace diagnostics" },
				F = { vim.diagnostic.open_float, "Floating diagnostics" },
				R = { "<CMD>Telescope lsp_references<CR>", "Show references" },
				S = { "<CMD>Telescope lsp_workspace_symbols<CR>", "Workspace symbols" },
				d = { "<CMD>TroubleToggle document_diagnostics<CR>", "Document diagnostics" },
				h = { require("lsp_signature").toggle_float_win, "Toggle signature help" },
				s = { "<CMD>Telescope lsp_document_symbols<CR>", "Document symbols" },
			},
			["<leader>t"] = {
				name = "DAP",
				B = {
					function()
						require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
					end,
					"Toggle conditional breakpoint",
				},
				b = { require("dap").toggle_breakpoint, "Toggle breakpoint" },
				u = { require("dapui").toggle, "Toggle UI" },
			},
		}, { buffer = event.buf })

		wk.register({
			["<leader>a"] = { require("actions-preview").code_actions, "Code actions" },
		}, {
			mode = "v",
			buffer = event.buf,
		})

		autocmd("FileType", {
			pattern = { "python" },
			group = augroup,
			callback = function(ev)
				wk.register({
					["<leader>t"] = {
						name = "DAP",
						t = { require("dap-python").test_file, "Test file (python)" },
						d = { require("dap-python").debug_file, "Debug file (python)" },
					},
				}, { buffer = ev.buf })

				wk.register({
					["<leader>t"] = {
						name = "DAP",
						d = { require("dap-python").debug_selection, "Debug selection (python)" },
					},
				}, {
					mode = "v",
					buffer = ev.buf,
				})
			end,
		})
	end,
})
