local map = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup("MarkdownQuartoConfig", { clear = true })

local quarto_settings = function()
	require("otter").setup({
		opts = {
			lsp = {
				hover = {
					border = require("core.utils").border,
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
	require("which-key").register({
		mode = "n",
		buffer = 0,
		["<leader>z"] = { name = "zotero" },
	})

	map("n", "<leader>me", require("nabla").popup, { desc = "Equation preview", buffer = 0 })
	map("n", "<leader>zc", "<Plug>ZCitationCompleteInfo", { desc = "Citation info (complete)", buffer = 0 })
	map("n", "<leader>zi", "<Plug>ZCitationInfo", { desc = "Citation info", buffer = 0 })
	map("n", "<leader>zo", "<Plug>ZOpenAttachment", { desc = "Open attachment", buffer = 0 })
	map("n", "<leader>zv", "<Plug>ZViewDocument", { desc = "View exported document", buffer = 0 })
	map("n", "<leader>zy", "<Plug>ZCitationYamlRef", { desc = "Citation info (yaml)", buffer = 0 })
end

autocmd("FileType", {
	pattern = { "markdown", "quarto" },
	group = group,
	callback = function()
		vim.g.slime_cell_delimiter = "```"
		vim.wo.breakindent = true
		vim.wo.linebreak = true
		vim.wo.showbreak = "|"
		vim.wo.wrap = true

		require("which-key").register({
			mode = "n",
			buffer = 0,
			["<leader>m"] = { name = "markdown" },
		})

		map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown preview", buffer = 0 })

		if vim.fn.has("mac") == 0 then
			quarto_settings()
			zotero_settings()
		end
	end,
})
