local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action
local mux = wezterm.mux
local nerdfonts = wezterm.nerdfonts

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

config.check_for_updates = false
config.command_palette_font_size = 16.0
config.default_prog = { "zsh" }
config.enable_wayland = false
config.hide_tab_bar_if_only_one_tab = false
config.inactive_pane_hsb = { saturation = 0.5, brightness = 0.7 }
config.status_update_interval = 500
config.tab_and_split_indices_are_zero_based = false
config.tab_bar_at_bottom = true
config.tab_max_width = 15
config.use_fancy_tab_bar = false
config.window_close_confirmation = "AlwaysPrompt"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 1 }

config.unix_domains = {
	{ name = "unix" },
}

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
	window:set_left_status(wezterm.format({
		{ Text = " " },
		{ Text = nerdfonts.md_tab },
		{ Text = " " },
	}))

	window:set_right_status(wezterm.format({
		{ Text = " " },
		{ Text = nerdfonts.cod_terminal_tmux },
		{ Text = " " },
		{ Text = window:active_workspace() },
		{ Text = " " },
	}))
end)

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local tab_title = function(tab_info)
		local title = tab_info.tab_title
		local len = string.len(title)

		if len == 0 then
			title = tab_info.active_pane.title
		end

		if len > max_width then
			title = wezterm.truncate_right(title, max_width - 7) .. "..."
		end

		return title
	end

	local tab_index = function(tab_info)
		local index = tab_info.tab_index + 1

		if index < 10 then
			return nerdfonts[string.format("md_numeric_%d_box_outline", index)]
		end

		return nerdfonts.md_numeric_9_plus_box_outline
	end

	local tab_zoomed = function(tab_info)
		if tab_info.active_pane.is_zoomed then
			return " " .. nerdfonts.cod_zoom_in
		end

		return ""
	end

	return {
		{ Text = tab_zoomed(tab) },
		{ Text = " " },
		{ Text = tab_index(tab) },
		{ Text = " " },
		{ Text = tab_title(tab) },
		{ Text = " " },
	}
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
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
