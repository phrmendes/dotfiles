local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- autogroups
local ft_group = augroup("UserFiletypesSettings", { clear = true })
local term_group = augroup("UserTermSettings", { clear = true })
local hl_group = augroup("YankHighlight", { clear = true })

-- autocmds
autocmd("TermOpen", {
	group = term_group,
	command = [[setlocal nonumber norelativenumber]],
})

autocmd("BufEnter", {
	pattern = "*.pdf",
	group = ft_group,
	command = [[execute "!zathura '%'" | bdelete %]],
})

autocmd("FileType", {
	pattern = "quarto",
	group = ft_group,
	command = [[set filetype=markdown]],
})

autocmd("TextYankPost", {
	pattern = "*",
	group = hl_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})
