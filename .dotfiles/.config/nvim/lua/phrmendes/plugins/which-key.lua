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
	["s"] = { "<cmd>w<cr>", "Save" },
	["S"] = { "<cmd>wq<cr>", "Save and quit" },
	["q"] = { "<cmd>q<cr>", "Quit" },
	["Q"] = { "<cmd>q!<cr>", "Quit without saving" },
	["n"] = { "<cmd>noh<cr>", "Clear highlights" },

	b = {
		name = "+buffer",
		["b"] = { "<cmd>Telescope buffers<cr>", "Find buffers" },
		["p"] = { "<cmd>BufferLineCyclePrev<cr>", "Previous buffer" },
		["n"] = { "<cmd>BufferLineCycleNext<cr>", "Next buffer" },
		["d"] = { "<cmd>bd<cr>", "Delete buffer" },

		c = {
			name = "+pick",
			["c"] = { "<cmd>BufferLinePick<cr>", "Pick buffer" },
			["d"] = { "<cmd>BufferLinePickClose<cr>", "Pick and close buffer" },
		},
	},

	f = {
		name = "+file",
		["t"] = { "<cmd>NvimTreeToggle<cr>", "NvimTree toggle" },
		["f"] = { "<cmd>Telescope find_files hidden=true<cr>", "Find files" },
		["g"] = { "<cmd>Telescope live_grep<cr>", "Live grep in project" },
		["s"] = { "<cmd>Telescope grep_string<cr>", "Find string in cursor" },
		["h"] = { "<cmd>Telescope help_tags<cr>", "Help tags" },
	},

	g = {
		name = "+git",
		["g"] = { "<cmd>LazyGit<cr>", "LazyGit" },
		["p"] = { "<cmd>Telescope repo list<cr>", "List all git repos" },
	},

	m = {
		name = "+markdown/quarto",
		["b"] = { "<cmd>Telescope bibtex<cr>", "Insert bibliography" },

		m = {
			name = "+markdown",
			["p"] = { "<cmd>MarkdownPreview<cr>", "Preview markdown document" },
			["s"] = { "<cmd>MarkdownPreviewStop<cr>", "Stop markdown preview" },
		},

		q = {
			name = "+quarto",
			["a"] = { "<cmd>QuartoActivate<cr>", "Activate quarto document" },
			["p"] = { "<cmd>QuartoPreview<cr>", "Preview quarto document" },
			["s"] = { "<cmd>QuartoClosePreview<cr>", "Stop quarto preview" },
			["r"] = { "<cmd>QuartoRender<cr>", "Render quarto document" },
		},
	},

	w = {
		name = "+windows",
		["v"] = { "<cmd>vsplit<cr>", "Split vertically" },
		["h"] = { "<cmd>split<cr>", "Split horizontally" },
		["e"] = { "<C-w>=<cr>", "Equalize windows" },
		["m"] = { "<cmd>MaximizerToggle<cr>", "Maximize window" },
	},
}

which_key.setup(conf)
which_key.register(mappings, opts)
