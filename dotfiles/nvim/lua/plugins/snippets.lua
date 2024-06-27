require("snippets").setup({
	create_cmp_source = true,
	friendly_snippets = true,
	search_paths = { vim.env.HOME .. "/.config/nvim/snippets" },
	extended_filetypes = {
		html = { "jinja", "template" },
		tex = { "markdown" },
		markdown = { "quarto" },
	},
})
