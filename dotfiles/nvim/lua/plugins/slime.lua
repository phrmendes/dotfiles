local target, config

if vim.env.ZELLIJ then
	target = "zellij"
	config = { session_id = "current", relative_pane = "right" }
else
	target = "kitty"
	config = { listen_on = os.getenv("KITTY_LISTEN_ON"), window_id = 2 }
end

vim.g.slime_bracketed_paste = 1
vim.g.slime_default_config = config
vim.g.slime_no_mappings = 1
vim.g.slime_target = target
