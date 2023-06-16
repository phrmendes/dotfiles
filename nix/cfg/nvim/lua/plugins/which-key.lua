local setup, which_key = pcall(require, "which-key")
if not setup then
	return
end

local conf = {
	window = {
		border = "single",
		position = "bottom",
	},
}

which_key.setup(conf)

-- local leader prefix normal mappings
local localleader_prefix_normal_opts = {
	mode = "n",
	prefix = "<localleader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local localleader_normal_mappings = {
	r = {
		name = "+REPL",
		["F"] = { "<cmd>IronFocus<cr>", "Focus" },
		["R"] = { "<cmd>IronRestart<cr>", "Restart" },
		["h"] = { "<cmd>IronHide<cr>", "Hide" },
		["o"] = { "<cmd>IronRepl<cr>", "Open" },
	},
}

which_key.register(localleader_normal_mappings, localleader_prefix_normal_opts)

-- g prefix normal mappings
local g_normal_opts = {
	mode = "n",
	prefix = "g",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local g_normal_mappings = {
	["D"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "LSP - Declaration" },
	["R"] = { "<cmd>Telescope lsp_references<cr>", "LSP - References" },
	["a"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "LSP - Code action" },
	["d"] = { "<cmd>Telescope lsp_definitions<cr>", "LSP - Definition" },
	["h"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "LSP - Hover" },
	["i"] = { "<cmd>Telescope lsp_implementations<cr>", "LSP - Implementation" },
	["r"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "LSP - Rename" },
	["s"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "LSP - Signature help" },
	["t"] = { "<cmd>Telescope lsp_type_definitions<cr>", "LSP - Type definition" },

	T = {
		name = "+trouble",
		["L"] = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
		["d"] = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document diagnostics" },
		["l"] = { "<cmd>TroubleToggle lsp_references<cr>", "LSP references" },
		["q"] = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
		["w"] = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace diagnostics" },
	},

	p = {
		name = "+LSP - Preview",
		["D"] = { "<cmd>lua require('goto-preview').close_all_win()<cr>", "Close all windows" },
		["d"] = { "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", "Definition" },
		["i"] = { "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>", "Implementation" },
		["r"] = { "<cmd>lua require('goto-preview').goto_preview_references()<cr>", "References" },
		["t"] = { "<cmd>lua require('goto-preview').goto_preview_type_definition()<cr>", "Type definition" },
	},
}

which_key.register(g_normal_mappings, g_normal_opts)

-- leader normal mappings
local leader_normal_opts = {
	mode = "n",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local leader_normal_mappings = {
	["."] = { "<cmd>Alpha<cr>", "Dashboard" },
	["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	["h"] = { "<cmd>Telescope help_tags<cr>", "Help tags" },
	["o"] = { "<cmd>split ~/pCloudDrive/notes/todo.txt<cr>", "Open todo.txt" },
	["u"] = { "<cmd>UndotreeToggle<cr>", "Undo Tree" },

	a = {
		name = "+actions",
		["Q"] = { "<cmd>q!<cr>", "Quit withoust saving" },
		["W"] = { "<cmd>wq<cr>", "Save and quit" },
		["n"] = { "<cmd>noh<cr>", "Clear highlights" },
		["q"] = { "<cmd>confirm q<cr>", "Quit" },
		["w"] = { "<cmd>w<cr>", "Save" },
	},

	b = {
		name = "+buffers",
		["b"] = { "<cmd>Telescope buffers previewer=false<cr>", "Buffers" },
		["d"] = { "<cmd>Bdelete<cr>", "Delete buffer" },
		["f"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy find" },
		["p"] = { "<cmd>bp<cr>", "Previous buffer" },
		["n"] = { "<cmd>bn<cr>", "Next buffer" },
		["g"] = { "<cmd>bf<cr>", "First buffer" },
		["G"] = { "<cmd>bl<cr>", "Last buffer" },

		s = {
			name = "+split",
			["p"] = { "<cmd>sbp<cr>", "Previous buffer" },
			["n"] = { "<cmd>sbn<cr>", "Next buffer" },
		},
	},

	d = {
		name = "+debugger",
		C = {
			"<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
			"Conditional breakpoint",
		},
		B = { "<cmd>lua require('dap').step_back()<cr>", "Step back" },
		b = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Toggle breakpoint" },
		c = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
		i = { "<cmd>lua require('dap').step_into()<cr>", "Step into" },
		o = { "<cmd>lua require('dap').step_over()<cr>", "Step over" },
		p = { "<cmd>lua require('dap').pause()<cr>", "Pause" },
		q = { "<cmd>lua require('dap').close()<cr>", "Quit" },
		s = { "<cmd>lua require('dap').continue()<cr>", "Start" },
		u = { "<cmd>lua require('dap').step_out()<cr>", "Step out" },
		r = { "<cmd>lua require('dapui').open({reset = true})<cr>", "Reset UI panes" },
		t = { "<cmd>lua require('dapui').toggle()<cr>", "Toggle UI" },
	},

	f = {
		name = "+files",
		["G"] = { "<cmd>Telescope live_grep<cr>", "Live grep in project" },
		["f"] = { "<cmd>Telescope find_files hidden=true<cr>", "Find" },
		["g"] = { "<cmd>Telescope git_files<cr>", "Find (git files)" },
		["p"] = { "<cmd>Telescope file_browser hidden=true<cr>", "File browser (project)" },
		["r"] = { "<cmd>Telescope oldfiles<cr>", "Open recent file" },
		["s"] = { "<cmd>Telescope grep_string<cr>", "Find string in cursor" },

		["S"] = {
			name = "+spectre",
			["s"] = { "<cmd>lua require('spectre').open()<cr>", "Search in project" },
			["w"] = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Search current word" },
			["v"] = { "<cmd>lua require('spectre').open_visual()<cr>", "Visual search" },
			["f"] = { "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>", "Search on current file" },
		},
	},

	g = {
		name = "+git",
		["C"] = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit (for current file)" },
		["b"] = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		["c"] = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
		["d"] = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
		["g"] = { "<cmd>LazyGit<cr>", "LazyGit" },
		["l"] = { "<cmd>lua require('gitsigns').blame_line()<cr>", "Blame" },
		["o"] = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		["p"] = { "<cmd>Telescope projects<cr>", "List projects" },
		["s"] = { "<cmd>Telescope repo list<cr>", "Search file in projects" },
		["r"] = { "<cmd>lua require('gitsigns').reset_buffer()<cr>", "Reset buffer" },
	},

	l = {
		name = "+lsp",
		["S"] = { "<cmd>SymbolsOutline<cr>", "Symbols tree" },
		["c"] = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens action" },
		["d"] = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
		["s"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
		["w"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace symbols" },
	},

	m = {
		name = "+markdown",
		["b"] = { "<cmd>Telescope bibtex<cr>", "Insert bibliography" },
		["p"] = { "<cmd>MarkdownPreview<cr>", "Preview markdown document" },
		["s"] = { "<cmd>MarkdownPreviewStop<cr>", "Stop markdown preview" },
	},

	t = {
		name = "+todo",
		["t"] = { "<cmd>TodoTrouble<cr>", "All todos" },
		["s"] = { "<cmd>TodoTelescope<cr>", "Search todos" },
	},

	T = {
		name = "+tabs",
		["d"] = { "<cmd>tabclose<cr>", "Close" },
		["n"] = { "<cmd>tabnext<cr>", "Next" },
		["p"] = { "<cmd>tabprevious<cr>", "Previous" },
		["t"] = { "<cmd>tabnew<cr>", "New" },
	},

	v = {
		name = "+vimwiki",
		["i"] = { "<cmd>VimwikiIndex<cr>", "Index (personal)" },
		["s"] = { "<cmd>VimwikiUISelect<cr>", "Select wiki" },
	},

	w = {
		name = "+windows",
		["d"] = { "<C-w>q", "Close" },
		["v"] = { "<C-w>s", "Vertical split" },
		["s"] = { "<C-w>v", "Split" },
		["n"] = { "<C-w>w", "Next" },
		["p"] = { "<C-w>p", "Previous" },
		["x"] = { "<C-w>x", "Swap" },
	},
}

which_key.register(leader_normal_mappings, leader_normal_opts)
