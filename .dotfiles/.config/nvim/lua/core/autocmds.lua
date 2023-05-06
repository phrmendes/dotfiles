local api = vim.api

local ft_group = api.nvim_create_augroup("customFileTypes", { clear = true })
local term_group = api.nvim_create_augroup("customTermSettings", { clear = true })

api.nvim_create_autocmd("BufRead,BufNewFile", {
	pattern = "*.qmd",
	command = "set filetype=markdown",
	group = ft_group,
})

api.nvim_create_autocmd("TermOpen", {
	command = "setlocal nonumber norelativenumber",
	group = term_group,
})
