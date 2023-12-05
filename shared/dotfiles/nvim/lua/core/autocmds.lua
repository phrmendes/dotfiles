local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- [[ augroups ]] -------------------------------------------------------
local hl_group = augroup("YankHighlight", { clear = true })
local term_group = augroup("UserTermSettings", { clear = true })

-- [[ autocmds ]] -------------------------------------------------------
autocmd({ "TermOpen" }, {
	group = term_group,
	pattern = { "*" },
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.api.nvim_command("startinsert")
	end,
})

autocmd({ "TermClose" }, {
	group = term_group,
	pattern = { "*" },
	callback = function()
		vim.wo.number = true
		vim.wo.relativenumber = true
	end,
})

autocmd("TextYankPost", {
	pattern = "*",
	group = hl_group,
	callback = function()
		vim.highlight.on_yank()
	end,
})
