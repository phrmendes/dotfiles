require("plugins.images")

local map = require("utils").map
local section = require("utils").section

vim.g.mkdp_filetypes = { "markdown", "quarto" }
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_no_default_key_mappings = 1
vim.cmd([[set [no]foldenable]])

local M = {}

M.markdown = function()
	section({
		mode = { "n", "v" },
		key = "<leader>m",
		name = "markdown",
		buffer = 0,
	})

	map({
		key = "]]",
		command = "<Plug>Markdown_MoveToNextHeader",
		desc = "Move to next header",
		buffer = 0,
	})

	map({
		key = "[[",
		command = "<Plug>Markdown_MoveToPreviousHeader",
		desc = "Move to previous header",
		buffer = 0,
	})

	map({
		key = "gx",
		command = "<Plug>Markdown_OpenUrlUnderCursor",
		desc = "Open URL under cursor",
		buffer = 0,
	})

	map({
		key = "ge",
		command = "<Plug>Markdown_EditUrlUnderCursor",
		desc = "Edit URL under cursor",
		buffer = 0,
	})

	map({
		key = "<leader>me",
		command = require("nabla").popup,
		desc = "Equation preview",
		buffer = 0,
	})

	map({
		key = "<leader>mm",
		command = "<cmd>MarkdownPreviewToggle<cr>",
		desc = "Markdown preview",
		buffer = 0,
	})

	map({
		key = "<leader>mp",
		command = "<cmd>PasteImage<cr>",
		desc = "Paste image",
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
