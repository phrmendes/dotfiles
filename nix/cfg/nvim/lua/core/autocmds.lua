local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- autogroups
local ft_group = augroup("customFiletypes", { clear = true })
local term_group = augroup("customTermSettings", { clear = true })

-- autocmds
autocmd("BufRead,BufNewFile", {
	pattern = "*.qmd",
	command = "set filetype=markdown",
	group = ft_group,
})

autocmd("TermOpen", {
	command = "setlocal nonumber norelativenumber",
	group = term_group,
})

autocmd("BufEnter", {
	pattern = "*.pdf",
	command = "!zathura % | bd %",
	group = ft_group,
})
