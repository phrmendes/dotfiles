local vimwiki_dir = vim.env.NOTES_DIR .. "/wiki"

vim.g.vimwiki_filetypes = { "markdown" }
vim.g.vimwiki_key_mappings = { all_maps = 0 }
vim.g.vimwiki_markdown_link_ext = 1

vim.g.vimwiki_list = {
	{
		path = vimwiki_dir,
		path_html = vimwiki_dir .. "/html",
		syntax = "markdown",
		ext = ".md",
	},
}
