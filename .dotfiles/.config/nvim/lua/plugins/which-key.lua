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

local opts = {
	mode = "n",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local mappings = {
	["."] = { "<cmd>Alpha<cr>", "Dashboard" },
	["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	["u"] = { "<cmd>UndotreeToggle<cr>", "Undo Tree" },

	a = {
		name = "+actions",
		["Q"] = { "<cmd>q!<cr>", "Quit without saving" },
		["W"] = { "<cmd>wq<cr>", "Save and quit" },
		["n"] = { "<cmd>noh<cr>", "Clear highlights" },
		["q"] = { "<cmd>confirm q<cr>", "Quit" },
		["w"] = { "<cmd>w<cr>", "Save" },
	},

	b = {
		name = "+buffers",
		["b"] = { "<cmd>Telescope buffers previewer=false<cr>", "Buffers" },
		["d"] = { "<cmd>bd<cr>", "Delete buffer" },
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
		name = "+debug",
		["U"] = { "<cmd>lua require('dapui').toggle({reset = true})<cr>", "Toggle DAP UI" },
		["b"] = { "<cmd>lua require('dap').step_back()<cr>", "Step back" },
		["c"] = { "<cmd>lua require('dap').continue()<cr>", "Continue" },
		["i"] = { "<cmd>lua require('dap').step_into()<cr>", "Step into" },
		["o"] = { "<cmd>lua require('dap').step_over()<cr>", "Step over" },
		["q"] = { "<cmd>lua require('dap').close()<cr>", "Quit" },
		["r"] = { "<cmd>lua require('dap').repl.toggle()<cr>", "Toggle DAP REPL" },
		["t"] = { "<cmd>lua require('dap').toggle_breakpoint()<cr>", "Toggle breakpoint" },
		["u"] = { "<cmd>lua require('dap').step_out()<cr>", "Step out" },
	},

	f = {
		name = "+files",
		["f"] = { "<cmd>Telescope find_files hidden=true<cr>", "Find" },
		["g"] = { "<cmd>Telescope live_grep hidden=true<cr>", "Live grep in project" },
		["h"] = { "<cmd>Telescope help_tags<cr>", "Help tags" },
		["r"] = { "<cmd>Telescope oldfiles<cr>", "Open recent file" },
		["s"] = { "<cmd>Telescope grep_string<cr>", "Find string in cursor" },
		["p"] = { "<cmd>Telescope file_browser hidden=true<cr>", "File browser (project)" },
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
		["p"] = { "<cmd>Telescope repo list<cr>", "List all repos" },
		["r"] = { "<cmd>lua require('gitsigns').reset_buffer()<cr>", "Reset buffer" },
	},

	l = {
		name = "+lsp",
		["R"] = { "<cmd>Telescope lsp_references<cr>", "References" },
		["S"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Dynamic workspace symbols" },
		["a"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code actions" },
		["b"] = { "<cmd>TagbarToggle<cr>", "Toggle Tagbar" },
		["i"] = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" },
		["l"] = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens action" },
		["r"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		["s"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
		["w"] = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace symbols" },

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
		name = "+documents",
		["b"] = { "<cmd>Telescope bibtex<cr>", "Insert bibliography" },
		["n"] = { "<cmd>require('nabla').popup()", "Preview equations" },
		["p"] = { "<cmd>MarkdownPreview<cr>", "Preview markdown document" },
		["q"] = { "<cmd>QuartoPreview<cr>", "Preview quarto document" },
		["s"] = { "<cmd>MarkdownPreviewStop<cr>", "Stop markdown preview" },
	},

	o = {
		name = "+obsidian",
		["b"] = { "<cmd>ObsidianBacklinks<cr>", "Backlinks" },
		["o"] = { "<cmd>ObsidianOpen<cr>", "Open note in app" },
		["n"] = { "<cmd>ObsidianNew<cr>", "New note" },
		["s"] = { "<cmd>ObsidianSearch<cr>", "Search" },
		["l"] = { "<cmd>ObsidianLink<cr>", "Link to note" },
		["f"] = { "<cmd>ObsidianFollowLink<cr>", "Follow link" },
		["k"] = { "<cmd>ObsidianLinkNew<cr>", "Create note and link to it" },
	},

	r = {
		name = "+REPL",
		["R"] = { "<cmd>IronRestart<cr>", "Restart" },
		["f"] = { "<cmd>IronFocus<cr>", "Focus" },
		["h"] = { "<cmd>IronHide<cr>", "Hide" },
		["r"] = { "<cmd>IronRepl<cr>", "Open" },
	},

	t = {
		name = "+tabs",
		["d"] = { "<cmd>tabclose<cr>", "Close" },
		["n"] = { "<cmd>tabnext<cr>", "Next" },
		["p"] = { "<cmd>tabprevious<cr>", "Previous" },
		["t"] = { "<cmd>tabnew<cr>", "New" },
	},

	w = {
		name = "+windows",
		["+"] = { "<C-w>+", "Increase height" },
		["-"] = { "<C-w>-", "Decrease height" },
		["<"] = { "<C-w><", "Decrease width" },
		[">"] = { "<C-w>>", "Increase width" },
		["e"] = { "<C-w>=<cr>", "Equalize" },
		["h"] = { "<C-w>s", "Split horizontally" },
		["q"] = { "<C-w>q", "Close" },
		["v"] = { "<C-w>v<cr>", "Split vertically" },
		["m"] = { "<cmd>MaximizerToggle<cr>", "Maximize window" },
	},
}

which_key.setup(conf)
which_key.register(mappings, opts)
