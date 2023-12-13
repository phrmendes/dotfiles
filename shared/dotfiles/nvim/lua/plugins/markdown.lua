local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local map = require("utils").map
local section = require("utils").section

local group = augroup("MarkdownQuartoConfig", { clear = true })

local quarto_settings = function()
	require("otter").setup({
		opts = {
			lsp = {
				hover = {
					border = require("utils").border,
				},
			},
			buffers = {
				set_filetype = true,
			},
		},
	})

	require("quarto").setup({
		lspFeatures = {
			languages = { "python", "bash", "lua" },
		},
	})
end

local zotero_settings = function()
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

autocmd("FileType", {
	pattern = { "markdown", "quarto" },
	group = group,
	callback = function()
		section({
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

		quarto_settings()

		if vim.fn.has("mac") == 0 then
			zotero_settings()
		end
	end,
})
