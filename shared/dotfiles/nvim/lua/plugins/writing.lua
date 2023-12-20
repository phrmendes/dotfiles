local map = require("utils").map
local section = require("utils").section

vim.g.bullets_checkbox_markers = " x"
vim.g.bullets_checkbox_partials_toggle = 1
vim.g.bullets_enabled_file_types = { "markdown", "quarto" }
vim.g.bullets_set_mappings = 0
vim.g.mkdp_filetypes = { "markdown", "quarto" }

local M = {}

M.markdown = function()
	section({
		mode = { "n", "v" },
		key = "<leader>m",
		name = "markdown",
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
end

M.bullets = function()
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
end

M.zotero = function()
	section({
		key = "<leader>z",
		name = "zotero",
		buffer = 0,
	})

	map({
		key = "<leader>zc",
		command = "<Plug>ZCitationCompleteInfo",
		buffer = 0,
		desc = "Citation info (complete)",
	})

	map({
		key = "<leader>zi",
		command = "<Plug>ZCitationInfo",
		desc = "Citation info",
		buffer = 0,
	})

	map({
		key = "<leader>zo",
		command = "<Plug>ZOpenAttachment",
		desc = "Open attachment",
		buffer = 0,
	})

	map({
		key = "<leader>zv",
		command = "<Plug>ZViewDocument",
		desc = "View exported document",
		buffer = 0,
	})

	map({
		key = "<leader>zy",
		command = "<Plug>ZCitationYamlRef",
		desc = "Citation info (yaml)",
		buffer = 0,
	})
end

return M
