local g = vim.g

g.vimwiki_global_ext = 0
g.vimwiki_filetypes = { "markdown" }
g.vimwiki_listsyms = "x "
g.vimwiki_key_mappings = { all_maps = 0 }
g.vimwiki_list = {
	{
		path = "~/pCloudDrive/notes/personal",
		name = "Personal",
		syntax = "markdown",
		ext = ".md",
		auto_tags = 1,
		path_html = "/tmp/vimwiki/",
		custom_wiki2html = "vimwiki_markdown",
	},
	{
		path = "~/pCloudDrive/notes/thesis",
		name = "Thesis",
		syntax = "markdown",
		ext = ".md",
		auto_tags = 1,
		path_html = "/tmp/vimwiki/",
		custom_wiki2html = "vimwiki_markdown",
	},
}
