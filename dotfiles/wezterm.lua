local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local action = wezterm.action
local config = wezterm.config_builder()

config.check_for_updates = false
config.default_prog = { "zsh" }
config.inactive_pane_hsb = { saturation = 0.5, brightness = 0.7 }
config.status_update_interval = 1000
config.use_fancy_tab_bar = false
config.window_close_confirmation = "AlwaysPrompt"
config.tab_bar_at_bottom = true

wezterm.on("update-status", function(window, pane)
	local ws = window:active_workspace()
	local cmd = pane:get_foreground_process_name()
	local cwd = pane:get_current_working_dir().file_path

	window:set_right_status(wezterm.format({
		{ Text = "[" .. wezterm.nerdfonts.oct_table .. " " .. ws .. "]" },
		{ Text = "[" .. wezterm.nerdfonts.fa_code .. " " .. cmd .. "]" },
		{ Text = "[" .. wezterm.nerdfonts.md_folder .. " " .. cwd .. "]" },
		{ Text = " " },
	}))
end)

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	{ key = "Space", mods = "LEADER|CTRL", action = action.SendKey({ key = "Space", mods = "CTRL" }) },
	{ key = "-", mods = "LEADER", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "LEADER", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "[", mods = "LEADER", action = action.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = action.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = action.SpawnTab("CurrentPaneDomain") },
	{ key = "p", mods = "LEADER", action = action.ActivateCommandPalette },
	{ key = "q", mods = "LEADER", action = action.CloseCurrentPane({ confirm = true }) },
	{ key = "r", mods = "LEADER", action = action.RotatePanes("Clockwise") },
	{ key = "t", mods = "LEADER", action = action.ShowTabNavigator },
	{ key = "y", mods = "LEADER", action = action.ActivateCopyMode },
	{ key = "z", mods = "LEADER", action = action.TogglePaneZoomState },
	{ key = "{", mods = "LEADER", action = action.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER", action = action.MoveTabRelative(1) },
	{ key = "w", mods = "LEADER", action = action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = action.ActivateTab(i),
	})
end

smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL",
		resize = "CTRL|SHIFT",
	},
})

return config
