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
	["t"] = { "<cmd>Telescope lsp_type_definition()<cr>", "LSP - Type definition" },

	p = {
		name = "+LSP - go to",
		["d"] = { "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", "Definition" },
		["i"] = { "<cmd>lua require('goto-preview').goto_preview_implementation()<cr>", "Implementation" },
		["q"] = { "<cmd>lua require('goto-preview').close_all_win()<cr>", "Close all windows" },
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
		["D"] = { "<cmd>BufferLinePickClose<cr>", "Pick and close" },
		["b"] = { "<cmd>Telescope buffers previewer=false<cr>", "Buffers" },
		["c"] = { "<cmd>BufferLinePick<cr>", "Pick" },
		["d"] = { "<cmd>bd!<cr>", "Delete buffer" },
		["f"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy find" },
		["h"] = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
		["l"] = { "<cmd>BufferLineCloseRight<cr>", "Close all to the right" },
		["n"] = { "<cmd>BufferLineCycleNext<cr>", "Next" },
		["p"] = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },

		s = {
			name = "+sort",
			["d"] = { "<cmd>BufferLineSortByDirectory<cr>", "Sort by directory" },
			["e"] = { "<cmd>BufferLineSortByExtension<cr>", "Sort by extension" },
			["r"] = { "<cmd>BufferLineSortByRelativeDirectory<cr>", "By relative directory" },
			["t"] = { "<cmd>BufferLineSortByTabs<cr>", "By tabs" },
		},
	},

	d = {
		name = "+debugger",
		C = {
			"<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
			"Conditional breakpoint",
		},
		U = { "<cmd>lua require('dapui').toggle({reset = true})<cr>", "Toggle UI" },
		b = { "<cmd>lua require('dap').step_back()<cr>", "Step back" },
		c = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
		i = { "<cmd>lua require('dap').step_into()<cr>", "Step into" },
		o = { "<cmd>lua require('dap').step_over()<cr>", "Step over" },
		p = { "<cmd>lua require('dap').pause()<cr>", "Pause" },
		q = { "<cmd>lua require('dap').close()<cr>", "Quit" },
		s = { "<cmd>lua require('dap').continue()<cr>", "Start" },
		t = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Toggle breakpoint" },
		u = { "<cmd>lua require('dap').step_out()<cr>", "Step out" },
	},

	f = {
		name = "+files",
		["G"] = { "<cmd>Telescope live_grep<cr>", "Live grep in project" },
		["f"] = { "<cmd>Telescope find_files hidden=true<cr>", "Find" },
		["g"] = { "<cmd>Telescope git_files<cr>", "Find (git files)" },
		["p"] = { "<cmd>Telescope file_browser hidden=true<cr>", "File browser (project)" },
		["r"] = { "<cmd>Telescope oldfiles<cr>", "Open recent file" },
		["s"] = { "<cmd>Telescope grep_string<cr>", "Find string in cursor" },
		["b"] = {
			"<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
			"File browser (current buffer)",
		},

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
		["q"] = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix window" },
		["s"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
		["t"] = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
		["w"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace symbols" },
	},

	m = {
		name = "+markdown",
		["b"] = { "<cmd>Telescope bibtex<cr>", "Insert bibliography" },
		["p"] = { "<cmd>MarkdownPreview<cr>", "Preview markdown document" },
		["s"] = { "<cmd>MarkdownPreviewStop<cr>", "Stop markdown preview" },
	},

	r = {
		name = "+REPL",
		["R"] = { "<cmd>IronRestart<cr>", "Restart" },
		["f"] = { "<cmd>IronFocus<cr>", "Focus" },
		["h"] = { "<cmd>IronHide<cr>", "Hide" },
		["o"] = { "<cmd>IronRepl<cr>", "Open" },
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
		["e"] = { "<cmd>FocusEqualise<cr>", "Equalize" },
		["h"] = { "<cmd>FocusSplitLeft<cr>", "Split left" },
		["j"] = { "<cmd>FocusSplitDown<cr>", "Split down" },
		["k"] = { "<cmd>FocusSplitUp<cr>", "Split up" },
		["l"] = { "<cmd>FocusSplitRight<cr>", "Split right" },
		["m"] = { "<cmd>FocusMaximise<cr>", "Maximize" },
		["s"] = { "<cmd>FocusSplitNicely<cr>", "Auto split" },
	},
}

which_key.register(leader_normal_mappings, leader_normal_opts)
