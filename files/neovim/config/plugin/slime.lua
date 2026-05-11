vim.g.slime_target = "neovim"
vim.g.slime_no_mappings = true

safely("filetype:python,r,rmd,quarto,julia,elixir", function()
  vim.keymap.set("n", "<c-c><c-c>", "<Plug>SlimeParagraphSend", { desc = "Send to terminal" })
  vim.keymap.set("n", "<c-c><c-s>", "<Plug>SlimeSettings", { desc = "Slime settings" })
  vim.keymap.set("x", "<c-c><c-c>", "<Plug>SlimeRegionSend", { desc = "Send to terminal" })
end)
