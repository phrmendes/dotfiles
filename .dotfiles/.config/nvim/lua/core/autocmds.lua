local cmd = vim.cmd

cmd([[ autocmd BufRead,BufNewFile *.qmd set ft=markdown ]])
cmd([[ autocmd BufRead,BufNewFile tarefas.md set ft=todo ]])
cmd([[ autocmd TermOpen * setlocal nonumber norelativenumber ]])
