return {
	{
		"tadmccorkle/markdown.nvim",
		ft = { "markdown", "quarto" },
		init = function() vim.g.markdown_fenced_languages = { "ts=typescript" } end,
		opts = {},
		keys = {
			{
				"<c-c>j",
				"<cmd>MDListItemBelow<cr>",
				mode = { "n", "i" },
				ft = { "markdown", "quarto" },
				desc = "Markdown: add item below",
			},
			{
				"<c-c>j",
				"<cmd>MDListItemAbove<cr>",
				mode = { "n", "i" },
				ft = { "markdown", "quarto" },
				desc = "Markdown: add item above",
			},
			{
				"<c-c>x",
				":MDTaskToggle<cr>",
				mode = { "n", "v" },
				ft = { "markdown", "quarto" },
				desc = "Markdown: toggle checkbox",
			},
			{
				"<c-i>",
				require("utils").toggle_emphasis("i"),
				ft = { "markdown", "quarto" },
				desc = "Markdown: toggle italic",
			},
			{
				"<c-b>",
				require("utils").toggle_emphasis("b"),
				ft = { "markdown", "quarto" },
				desc = "Markdown: toggle bold",
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown", "quarto" },
		build = "cd app && npm install",
		init = function() vim.g.mkdp_auto_close = 0 end,
		keys = {
			{ "<leader>p", "<cmd>MarkdownPreviewToggle<cr>", ft = { "markdown", "quarto" }, desc = "Preview markdown file" },
		},
	},
}
