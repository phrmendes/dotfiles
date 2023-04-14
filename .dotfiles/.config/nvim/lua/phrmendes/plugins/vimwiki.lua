local status, vimwiki = pcall(require, "vimwiki")
if not status then
	return
end

vim.g.vimwiki_list = {
	path = "~/pCloudDrive/notes",
	syntax = "markdown",
	ext = ".md",
}

vimwiki.setup()
