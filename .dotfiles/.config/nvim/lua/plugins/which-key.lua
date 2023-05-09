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

-- local leader normal mappings

local local_leader_normal_opts = {
	mode = "n",
	prefix = "<localleader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local local_leader_normal_mappings = {
	["<Backspace>"] = { "<cmd>VimwikiGoBackLink<cr>", "Vimwiki - Go back" },
	["<CR>"] = { "<cmd>VimwikiFollowLink<cr>", "Vimwiki - Follow link" },
	["<Left>"] = { "<cmd>VimwikiTableMoveColumnLeft<cr>", "Vimwiki - Move table column to left" },
	["<Right>"] = { "<cmd>VimwikiTableMoveColumnRight<cr>", "Vimwiki - Move table column to right" },
	["<S-Tab>"] = { "<cmd>VimwikiPrevLink<cr>", "Vimwiki - Next link" },
	["<Tab>"] = { "<cmd>VimwikiNextLink<cr>", "Vimwiki - Next link" },
	["a"] = { "<cmd>VimwikiTableAlignQ<cr>", "Vimwiki - Align table" },
	["b"] = { "<cmd>VimwikiBacklinks<cr>", "Vimwiki - Backlinks" },
	["c"] = { "<cmd>VimwikiCheckLinks", "Vimwiki - Check links" },
	["d"] = { "<cmd>VimwikiDeleteFile", "Vimwiki - Delete file" },
	["e"] = { "<cmd>Vimwiki2HTMLBrowse<cr>", "Vimwiki - Export wiki to HTML" },
	["g"] = { "<cmd>VimwikiGoto<cr>", "Vimwiki - Go to or create new wiki page" },
	["n"] = { "<cmd>VimwikiNextTask<cr>", "Vimwiki - Next task" },
	["r"] = { "<cmd>VimwikiRenameFile<cr>", "Vimwiki - Rename file" },
	["t"] = { "<cmd>VimwikiTOC<cr>", "Vimwiki - Table of contents" },
	["x"] = { "<cmd>VimwikiToggleListItem<cr>", "Vimwiki - Toggle list item" },
}

which_key.register(local_leader_normal_mappings, local_leader_normal_opts)

-- local leader visual mappings

local local_leader_visual_opts = {
	mode = "v",
	prefix = "<localleader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local local_leader_visual_mappings = {
	["p"] = { "<cmd>lua require('dap-python').debug_selection()", "DAP - Debug python region" },
}

which_key.register(local_leader_visual_mappings, local_leader_visual_opts)

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
	["R"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "LSP - References" },
	["a"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "LSP - Code action" },
	["d"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "LSP - Definition" },
	["f"] = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "LSP - Formatting" },
	["h"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "LSP - Hover" },
	["i"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "LSP - Implementation" },
	["r"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "LSP - Rename" },
	["s"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "LSP - Signature help" },
	["t"] = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "LSP - Type definition" },
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
	["H"] = { "<cmd>Telescope help_tags<cr>", "Help tags" },
	["T"] = { "<cmd>TagbarToggle<cr>", "Toggle Tagbar" },
	["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
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
		["d"] = { "<cmd>bd!<cr>", "Delete buffer" },
		["l"] = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
		["n"] = { "<cmd>BufferLineCycleNext<cr>", "Next" },
		["p"] = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
		["r"] = { "<cmd>BufferLineCloseRight<cr>", "Close all to the right" },
		["f"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy find" },

		c = {
			name = "+pick",
			["c"] = { "<cmd>BufferLinePick<cr>", "Pick" },
			["d"] = { "<cmd>BufferLinePickClose<cr>", "Pick and close" },
		},

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

		G = {
			name = "+go",
			["t"] = { "<cmd>lua require('dap-go').debug_test()<cr>", "Debug test" },
			["l"] = { "<cmd>lua require('dap-go').debug_latest_test()<cr>", "Debug latest test" },
		},

		P = {
			name = "+python",
			["c"] = { "<cmd>lua require('dap-python').test_class()<cr>", "Test method" },
			["m"] = { "<cmd>lua require('dap-python').test_method()<cr>", "Test method" },
		},
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
		["i"] = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" },
		["c"] = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens action" },
		["r"] = { "<cmd>Telescope lsp_references<cr>", "References" },
		["s"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
		["w"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace symbols" },

		t = {
			name = "+trouble",
			["a"] = { "<cmd>TroubleToggle lsp_type_definitions<cr>", "LSP type definitions" },
			["d"] = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document diagnostics" },
			["f"] = { "<cmd>TroubleToggle lsp_definitions<cr>", "LSP definitions" },
			["l"] = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
			["q"] = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
			["r"] = { "<cmd>TroubleToggle lsp_references<cr>", "LSP references" },
			["t"] = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
			["w"] = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace diagnostics" },
		},
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
