local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local clear = vim.api.nvim_clear_autocmds

-- autogroups
local ft = augroup("CustomFiletypes", { clear = true })
local term = augroup("CustomTermSettings", { clear = true })

-- autocmds
-- autocmd("BufRead,BufNewFile", {
--     pattern = "*.qmd",
--     command = [[set filetype=markdown]],
--     group = ft_group
-- })

autocmd("TermOpen",
    { command = [[setlocal nonumber norelativenumber]], group = term })

autocmd("BufEnter", {
    pattern = "*.pdf",
    command = [[execute "!zathura '%'" | bdelete %]],
    group = ft
})