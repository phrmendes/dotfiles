require("snippets").setup({
	create_cmp_source = true,
	friendly_snippets = true,
	search_paths = { vim.fn.stdpath("config") .. "/snippets" },
	extended_filetypes = {
		markdown = { "tex" },
		quarto = { "markdown" },
		jinja = { "html" },
		template = { "html" },
	},
})
