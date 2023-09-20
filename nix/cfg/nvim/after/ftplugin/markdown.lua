local wk = require("which-key")
local nabla = require("nabla")
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

local leader = {
	normal = {
		options = {
			mode = "n",
			prefix = "<leader>",
			buffer = nil,
			silent = true,
			noremap = true,
			nowait = false,
		},
		mappings = {
			m = {
				name = "+markdown",
				p = { "<cmd>MarkdownPreview<cr>", "Preview document" },
				s = { "<cmd>MarkdownPreviewStop<cr>", "Stop preview" },
				e = {
					function()
						nabla.toggle_virt()
					end,
                    "Toggle equation preview",
				},
			},
		},
	},
}

map("n", "<C-b>", "<cmd>Telescope bibtex<cr>", opts)
map("i", "<C-b>", "<cmd>Telescope bibtex<cr>", opts)

wk.register(leader.normal.mappings, leader.normal.options)
