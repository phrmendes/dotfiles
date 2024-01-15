local utils = require("utils")

local setup = function()
	vim.g.mkdp_filetypes = { "markdown", "quarto" }
	vim.wo.showbreak = "|"

	if not vim.g.neovide then
		require("plugins.images")
	end

	local list_patterns = {
		unordered = "[-+*]",
		digit = "%d+[.)]",
		ascii = "%a[.)]",
	}

	require("autolist").setup({
		lists = {
			quarto = {
				list_patterns.unordered,
				list_patterns.digit,
				list_patterns.ascii,
			},
			markdown = {
				list_patterns.unordered,
				list_patterns.digit,
				list_patterns.ascii,
			},
		},
	})

	require("cmp_pandoc").setup({
		filetypes = { "quarto" },
		crossref = { enable_nabla = true },
	})

	require("quarto").setup({
		codeRunner = {
			enabled = true,
			default_method = "slime",
			never_run = { "yaml" },
		},
	})

	utils.map({
		mode = "i",
		key = "<CR>",
		cmd = "<CR><CMD>AutolistNewBullet<CR>",
		desc = "Insert new bullet point",
	})

	utils.map({
		key = "<<",
		cmd = "<<<CMD>AutolistRecalculate<CR>",
		desc = "Recalculate indentation to the left",
	})

	utils.map({
		key = "<CR>",
		cmd = "<CMD>AutolistToggleCheckbox<CR>",
		desc = "Toggle checkbox",
	})

	utils.map({
		key = ">>",
		cmd = ">>><CMD>AutolistRecalculate<CR>",
		desc = "Recalculate indentation to the right",
	})

	utils.map({
		key = "O",
		cmd = "O<CMD>AutolistNewBulletBefore<CR>",
		desc = "Insert new bullet point before",
	})

	utils.map({
		key = "dd",
		cmd = "dd<CMD>AutolistRecalculate<CR>",
		desc = "Delete line and recalculate indentation",
	})

	utils.map({
		key = "o",
		cmd = "o<CMD>AutolistNewBullet<CR>",
		desc = "Insert new bullet point below",
	})

	utils.map({
		mode = "v",
		key = "d",
		cmd = "d<CMD>AutolistRecalculate<CR>",
		desc = "Delete selection and recalculate indentation",
	})

	utils.map({
		key = "<leader>p",
		cmd = "<CMD>PasteImage<CR>",
		desc = "Paste image",
	})

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
