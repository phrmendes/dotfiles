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
	[","] = { "<cmd>T<cr>", "Open terminal" },

	a = {
		name = "+actions",
		["S"] = { "<cmd>wq<cr>", "Save and quit" },
		["n"] = { "<cmd>noh<cr>", "Clear highlights" },
		["q"] = { "<cmd>confirm q<cr>", "Quit" },
		["s"] = { "<cmd>w<cr>", "Save" },
		["Q"] = { "<cmd>q!<cr>", "Quit without saving" },
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

	f = {
		name = "+files",
		["f"] = { "<cmd>Telescope find_files hidden=true<cr>", "Find" },
		["g"] = { "<cmd>Telescope live_grep<cr>", "Live grep in project" },
		["h"] = { "<cmd>Telescope help_tags<cr>", "Help tags" },
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
		["b"] = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		["c"] = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
		["d"] = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
		["l"] = { "<cmd>lua require('gitsigns').blame_line()<cr>", "Blame" },
		["o"] = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		["r"] = { "<cmd>lua require('gitsigns').reset_buffer()<cr>", "Reset buffer" },
		["g"] = { "<cmd>LazyGit<cr>", "LazyGit" },
		["C"] = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit (for current file)" },
	},

	l = {
		name = "+lsp",
		["b"] = { "<cmd>TagbarToggle<cr>", "Toggle Tagbar" },
		["a"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code actions" },
		["i"] = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" },
		["l"] = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens action" },
		["r"] = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		["s"] = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
		["w"] = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace symbols" },
		["R"] = { "<cmd>Telescope lsp_references<cr>", "References" },
		["S"] = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Dynamic workspace symbols" },

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
		["p"] = { "<cmd>MarkdownPreview<cr>", "Preview markdown document" },
		["s"] = { "<cmd>MarkdownPreviewStop<cr>", "Stop markdown preview" },
	},

	r = {
		name = "+REPL",
		["l"] = { "<cmd>TREPLSendLine<cr>", "Send line" },
		["f"] = { "<cmd>TREPLSendFile<cr>", "Send file" },
		["s"] = { "<cmd>TREPLSendSelection<cr>", "Send selection" },
	},

	t = {
		name = "+tabs",
		["c"] = { "<cmd>tabclose<cr>", "Close" },
		["n"] = { "<cmd>tabnext<cr>", "Next" },
		["p"] = { "<cmd>tabprevious<cr>", "Previous" },
		["t"] = { "<cmd>tabnew<cr>", "New" },
	},

	w = {
		name = "+windows",
		["h"] = { "<C-w>s", "Split horizontally" },
		["v"] = { "<C-w>v<cr>", "Split vertically" },
		["e"] = { "<C-w>=<cr>", "Equalize" },
		[">"] = { "<C-w>>", "Increase width" },
		["<"] = { "<C-w><", "Decrease width" },
		["+"] = { "<C-w>+", "Increase height" },
		["-"] = { "<C-w>-", "Decrease height" },
		["q"] = { "<C-w>q", "Close" },
	},
}

which_key.setup(conf)
which_key.register(mappings, opts)
