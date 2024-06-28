local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action
local mux = wezterm.mux
local nerdfonts = wezterm.nerdfonts

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

config.check_for_updates = false
config.default_prog = { "zsh" }
config.enable_wayland = false
config.hide_tab_bar_if_only_one_tab = false
config.inactive_pane_hsb = { saturation = 0.5, brightness = 0.7 }
config.status_update_interval = 1000
config.tab_and_split_indices_are_zero_based = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_close_confirmation = "AlwaysPrompt"
config.command_palette_font_size = 16.0
config.unix_domains = { { name = "unix" } }
config.default_gui_startup_args = { "connect", "unix" }

config.ssh_domains = {
	{
		name = "server",
		remote_address = "server",
		username = "phrmendes",
	},
	{
		name = "darwin",
		remote_address = "darwin",
		username = "prochame",
	},
	{
		name = "desktop",
		remote_address = "linux",
		username = "prochame",
	},
}

wezterm.on("update-status", function(window, _)
	local workspace = window:active_workspace()

	window:set_right_status(wezterm.format({
		{ Text = " [" },
		{ Text = nerdfonts.oct_table .. " " .. workspace },
		{ Text = "] " },
	}))
end)

wezterm.on("format-tab-title", function(tab, _)
	local function tab_title(tab_info)
		local title = tab_info.tab_title

		if title and #title > 0 then
			return title
		end

		return tab_info.active_pane.title
	end

	local index = tab.tab_index + 1
	local title = tab_title(tab)

	return {
		{ Text = " [" },
		{ Text = nerdfonts.cod_window .. " " .. index .. ": " .. title },
		{ Text = "] " },
	}
end)

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	{ key = "Space", mods = "LEADER|CTRL", action = action.SendKey({ key = "Space", mods = "CTRL" }) },
	{ key = "Enter", mods = "LEADER", action = action.RotatePanes("Clockwise") },
	{ key = "-", mods = "LEADER", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "\\", mods = "LEADER", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "[", mods = "LEADER", action = action.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = action.ActivateTabRelative(1) },
	{ key = "{", mods = "LEADER", action = action.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER", action = action.MoveTabRelative(1) },
	{ key = "d", mods = "LEADER", action = action.ShowLauncherArgs({ flags = "FUZZY|DOMAINS" }) },
	{ key = "n", mods = "LEADER", action = action.SpawnTab("CurrentPaneDomain") },
	{ key = "p", mods = "LEADER", action = action.ActivateCommandPalette },
	{ key = "q", mods = "LEADER", action = action.CloseCurrentPane({ confirm = true }) },
	{ key = "t", mods = "LEADER", action = action.ShowLauncherArgs({ flags = "FUZZY|TABS" }) },
	{ key = "w", mods = "LEADER", action = action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{ key = "y", mods = "LEADER", action = action.ActivateCopyMode },
	{ key = "z", mods = "LEADER", action = action.TogglePaneZoomState },
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Rename tab:",
			action = wezterm.action_callback(function(_, pane, line)
				if line then
					pane:tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "R",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Rename workspace:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(mux.rename_workspace(mux.get_active_workspace(), line), pane)
				end
			end),
		}),
	},
}

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
		resize = "CTRL|SHIFT",
	},
})

return config
