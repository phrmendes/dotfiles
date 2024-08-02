vim.g.slime_no_mappings = 1
vim.g.slime_bracketed_paste = 1

if vim.env.ZELLIJ then
	vim.g.slime_target = "zellij"
	vim.g.slime_default_config = { session_id = "current", relative_pane = "right" }
else
	vim.g.slime_target = "kitty"
	vim.g.slime_default_config = { listen_on = os.getenv("KITTY_LISTEN_ON"), window_id = 2 }
end
