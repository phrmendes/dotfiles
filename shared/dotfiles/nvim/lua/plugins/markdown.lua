local map = require("utils").map
local section = require("utils").section
local augroup = require("utils").augroup

local autocmd = vim.api.nvim_create_autocmd

vim.g.mkdp_filetypes = { "markdown", "quarto" }
vim.g.table_mode_map_prefix = "<leader>mt"
vim.g.table_mode_disable_mappings = 1
vim.g.table_mode_delimiter = ","

autocmd("FileType", {
	pattern = { "markdown", "quarto" },
	group = augroup,
	callback = function()
		section({
			mode = { "n", "v" },
			key = "<leader>m",
			name = "markdown",
			buffer = 0,
		})

		section({
			mode = { "n", "v" },
			key = "<leader>mt",
			name = "tables",
			buffer = 0,
		})

		section({
			key = "<leader>mti",
			name = "insert",
			buffer = 0,
		})

		section({
			key = "<leader>mtd",
			name = "delete",
			buffer = 0,
		})

		map({
			key = "<leader>mp",
			command = "<cmd>MarkdownPreviewToggle<cr>",
			desc = "Markdown preview",
			buffer = 0,
		})

		map({
			key = "<leader>me",
			command = require("nabla").popup,
			desc = "Equation preview",
			buffer = 0,
		})

		map({
			key = "<leader>mtt",
			command = "<cmd>TableModeToggle<cr>",
			desc = "Toggle mode",
			buffer = 0,
		})

		map({
			mode = { "n", "v" },
			key = "<leader>mtT",
			command = "<cmd>Tableize<cr>",
			desc = "Toggle mode",
			buffer = 0,
		})

		map({
			key = "<leader>mtr",
			command = "<cmd>TableModeRealign<cr>",
			desc = "Realign",
			buffer = 0,
		})

		map({
			mode = { "n", "v" },
			key = "<leader>mts",
			command = "<cmd>TableSort<cr>",
			desc = "Sort",
			buffer = 0,
		})

		map({
			key = "<leader>mtic",
			command = "<Plug>(table-mode-insert-column-after-map)",
			desc = "Column (after)",
			buffer = 0,
		})

		map({
			key = "<leader>mtiC",
			command = "<Plug>(table-mode-insert-column-before-map)",
			desc = "Column (before)",
			buffer = 0,
		})

		map({
			key = "<leader>mtdc",
			command = "<Plug>(table-mode-delete-column-map)",
			desc = "Column",
			buffer = 0,
		})

		map({
			key = "<leader>mtdr",
			command = "<Plug>(table-mode-delete-row-map)",
			desc = "Row",
			buffer = 0,
		})
	end,
})
