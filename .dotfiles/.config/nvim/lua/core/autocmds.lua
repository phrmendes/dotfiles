local cmd = vim.cmd

cmd([[ autocmd BufRead,BufNewFile *.qmd set filetype=quarto ]])
cmd([[ autocmd TermOpen * setlocal nonumber norelativenumber ]])
