local utils = require("utils")

local setup = function()
	vim.g.markdown_fenced_languages = { "python", "sh" }
	vim.g.mkdp_filetypes = { "markdown", "quarto" }
	vim.g.vim_markdown_folding_disabled = 1
	vim.wo.showbreak = "|"

	require("mdeval").setup({
		require_confirmation = false,
		results_label = "**OUTPUT:**",
		eval_options = {
			sh = { command = { "bash" } },
			python = { command = { "python" } },
		},
	})

	require("quarto").setup({
		codeRunner = {
			enabled = true,
			default_method = "slime",
			never_run = { "yaml" },
		},
	})

	utils.map({
		key = "<C-c><C-m>",
		cmd = "<CMD>MdEval<CR>",
		desc = "Run code block (markdown)",
	}, {
		silent = true,
		noremap = true,
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

	utils.map({
		key = "<leader>me",
		cmd = require("nabla").popup,
		desc = "Equation preview",
	})

	utils.map({
		key = "<leader>mp",
		cmd = "<CMD>MarkdownPreviewToggle<CR>",
		desc = "Markdown preview",
	})

	utils.map({
		key = "<leader>mt",
		cmd = "<CMD>! md-tangle -f %<CR>",
		desc = "Tangle code blocks",
	}, {
		silent = true,
		noremap = true,
	})

	utils.section({
		key = "<leader>z",
		name = "zotero",
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
