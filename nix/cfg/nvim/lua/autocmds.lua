local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- [[ augroups ]] -------------------------------------------------------
local hl_group = augroup("YankHighlight", { clear = true })
local term_group = augroup("UserTermSettings", { clear = true })

-- [[ autocmds ]] -------------------------------------------------------
autocmd("TermOpen", {
	group = term_group,
	command = [[setlocal nonumber norelativenumber]],
})

autocmd("TextYankPost", {
	pattern = "*",
	group = hl_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})
