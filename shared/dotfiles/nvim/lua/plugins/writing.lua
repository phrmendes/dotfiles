local utils = require("utils")

local setup = function()
	vim.g.mkdp_filetypes = { "markdown", "quarto" }
	vim.wo.showbreak = "|"

	if not vim.g.neovide then
		require("plugins.images")
	end

	require("autolist").setup()

	require("quarto").setup({
		codeRunner = {
			enabled = true,
			default_method = "slime",
			never_run = { "yaml" },
		},
	})

	vim.keymap.set("i", "<CR>", "<CR><CMD>AutolistNewBullet<CR>")
	vim.keymap.set("i", "<S-TAB>", "<CMD>AutolistShiftTab<CR>")
	vim.keymap.set("i", "<TAB>", "<CMD>AutolistTab<CR>")
	vim.keymap.set("n", "<<", "<<<CMD>AutolistRecalculate<CR>")
	vim.keymap.set("n", "<CR>", "<CMD>AutolistToggleCheckbox<CR><CR>")
	vim.keymap.set("n", ">>", ">><CMD>AutolistRecalculate<CR>")
	vim.keymap.set("n", "O", "O<CMD>AutolistNewBulletBefore<CR>")
	vim.keymap.set("n", "dd", "dd<CMD>AutolistRecalculate<CR>")
	vim.keymap.set("n", "o", "o<CMD>AutolistNewBullet<CR>")
	vim.keymap.set("v", "d", "d<CMD>AutolistRecalculate<CR>")

	utils.section({
		mode = { "n", "v" },
		key = "<leader>m",
		name = "markdown",
	})

	utils.section({
		key = "<leader>z",
		name = "zotero",
	})

	utils.map({
		key = "<leader>me",
		cmd = require("nabla").popup,
		desc = "Equation preview",
	})

	utils.map({
		key = "<leader>mm",
		cmd = "<CMD>MarkdownPreviewToggle<CR>",
		desc = "Markdown preview",
	})

	utils.map({
		key = "<leader>mp",
		cmd = "<CMD>PasteImage<CR>",
		desc = "Paste image",
	})

	utils.map({
		key = "<leader>zc",
		cmd = "<Plug>ZCitationCompleteInfo",
		desc = "Citation info (complete)",
	})

	utils.map({
		key = "<leader>zi",
		cmd = "<Plug>ZCitationInfo",
		desc = "Citation info",
	})

	utils.map({
		key = "<leader>zo",
		cmd = "<Plug>ZOpenAttachment",
		desc = "Open attachment",
	})

	utils.map({
		key = "<leader>zv",
		cmd = "<Plug>ZViewDocument",
		desc = "View exported document",
	})

	utils.map({
		key = "<leader>zy",
		cmd = "<Plug>ZCitationYamlRef",
		desc = "Citation info (yaml)",
	})
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "quarto" },
	group = utils.augroup,
	callback = setup,
})
