local g = vim.g
local notes = os.getenv("NOTES")

g.vimwiki_list = {
    {
        path = notes,
        syntax = "markdown",
        ext = ".md",
    },
}
