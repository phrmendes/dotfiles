local map = require("utils").map
local section = require("utils").section
local augroup = require("utils").augroup

local autocmd = vim.api.nvim_create_autocmd

vim.g.bullets_checkbox_markers = " x"
vim.g.bullets_checkbox_partials_toggle = 1
vim.g.bullets_enabled_file_types = { "markdown", "quarto" }
vim.g.bullets_set_mappings = 0
vim.g.mkdp_filetypes = { "markdown", "quarto" }
vim.g.table_mode_delimiter = ","
vim.g.table_mode_disable_mappings = 1

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
			desc = "Tableize",
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

		map({
			mode = "i",
			key = "<cr>",
			command = "<Plug>(bullets-newline)",
			desc = "New item",
			buffer = 0,
		})

		map({
			key = "o",
			command = "<Plug>(bullets-newline)",
			desc = "New item",
			buffer = 0,
		})

		map({
			mode = { "n", "v" },
			key = "gN",
			command = "<Plug>(bullets-renumber)",
			desc = "Renumber item",
			buffer = 0,
		})

		map({
			key = "<C-CR>",
			command = "<Plug>(bullets-toggle-checkbox)",
			desc = "Toggle checkbox",
			buffer = 0,
		})

		map({
			mode = { "n", "v" },
			key = ">>",
			command = "<Plug>(bullets-demote)",
			desc = "Demote item",
			buffer = 0,
		})

		map({
			mode = { "n", "v" },
			key = "<<",
			command = "<Plug>(bullets-promote)",
			desc = "Promote item",
			buffer = 0,
		})
	end,
})
