local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local action = wezterm.action
local config = wezterm.config_builder()

config.default_prog = { "zsh" }

config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}

config.leader = {
	key = "phys:Space",
	mods = "CTRL",
	timeout_milliseconds = 1000,
}

config.keys = {
	-- Send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER|CTRL", action = action.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "y", mods = "LEADER", action = action.ActivateCopyMode },
	{ key = "phys:Space", mods = "LEADER", action = action.ActivateCommandPalette },

	-- Pane keybindings
	{ key = "s", mods = "LEADER", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "q", mods = "LEADER", action = action.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = action.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = action.RotatePanes("Clockwise") },
	-- We can make separate keybindings for resizing panes
	-- But Wezterm offers custom "mode" in the name of "KeyTable"
	{
		key = "r",
		mods = "LEADER",
		action = action.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
	},

	-- Tab keybindings
	{ key = "t", mods = "LEADER", action = action.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = action.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = action.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = action.ShowTabNavigator },
	{
		key = "e",
		mods = "LEADER",
		action = action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Renaming Tab Title...:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Key table for moving tabs around
	{ key = "m", mods = "LEADER", action = action.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
	-- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
	{ key = "{", mods = "LEADER|SHIFT", action = action.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER|SHIFT", action = action.MoveTabRelative(1) },

	-- Lastly, workspace
	{ key = "w", mods = "LEADER", action = action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}
-- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = action.ActivateTab(i - 1),
	})
end

smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL",
		resize = "CTRL+SHIFT",
	},
})

return config
