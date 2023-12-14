local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local map = require("utils").map
local section = require("utils").section

local group = augroup("MarkdownQuartoConfig", { clear = true })

vim.g.mkdp_filetypes = { "markdown", "quarto" }

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
	end,
})
