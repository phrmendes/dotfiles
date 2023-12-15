local quarto = require("quarto")

local map = require("utils").map
local augroup = require("utils").augroup

local autocmd = vim.api.nvim_create_autocmd

quarto.setup({
	lspFeatures = {
		languages = { "bash", "lua", "python" },
	},
})

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

map({
	key = "<leader>mq",
	command = quarto.quartoPreview,
	desc = "Quarto preview",
	buffer = 0,
}, {
	silent = true,
	noremap = true,
})

autocmd("FileType", {
	pattern = "quarto",
	group = augroup,
	callback = function()
		vim.defer_fn(function()
			require("otter").activate({ "python", "sh" }, true)
		end, 500)
	end,
})
