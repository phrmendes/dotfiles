return {
	{
		"tadmccorkle/markdown.nvim",
		ft = { "markdown", "quarto" },
		init = function() vim.g.markdown_fenced_languages = { "ts=typescript" } end,
		opts = {},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown", "quarto" },
		build = "cd app && npm install",
		init = function() vim.g.mkdp_auto_close = 0 end,
	},
}
