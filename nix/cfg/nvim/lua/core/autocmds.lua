-- [[ variables ]] ------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- [[ augroups ]] -------------------------------------------------------
local of_group = augroup("UserOpenFiles", { clear = true })
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

autocmd("BufEnter", {
	pattern = "*.pdf",
	group = of_group,
	command = [[silent execute "!zathura --fork '%'" | lua require("mini.bufremove").delete()]],
})
