vim.g.slime_bracketed_paste = 1
vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
vim.g.slime_dont_ask_default = 1
vim.g.slime_target = "tmux"

vim.keymap.set({ "n", "v" }, "<C-c><C-c>", "<Plug>SlimeParagraphSend", { desc = "Send to REPL" })
vim.keymap.set({ "n", "v" }, "<C-c><C-v>", "<Plug>SlimeConfig", { desc = "Slime config" })
