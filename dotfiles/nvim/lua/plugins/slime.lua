local config
local target

if vim.env.WEZTERM_EXECUTABLE then
	target = "wezterm"
	config = { pane_direction = "right" }
elseif vim.env.KITTY_LISTEN_ON then
	target = "kitty"
	config = { listen_on = vim.env.KITTY_LISTEN_ON, window_id = 2 }
else
	target = "neovim"
end

vim.g.slime_no_mappings = true
vim.g.slime_target = target

if config then
	vim.g.slime_target_config = config
end
