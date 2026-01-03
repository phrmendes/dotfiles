vim.opt_local.shiftwidth = 2
vim.opt_local.commentstring = "# %s"

if not package.loaded["tf"] then require("tf").setup() end
