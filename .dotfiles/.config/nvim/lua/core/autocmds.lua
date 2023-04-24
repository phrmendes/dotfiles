local cmd = vim.cmd

cmd([[ autocmd BufRead,BufNewFile *.qmd set filetype=quarto ]])
