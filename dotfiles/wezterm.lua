local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action
local nf = wezterm.nerdfonts
local home = os.getenv("HOME")

local ss = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local ws = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local base_path = function(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

config.automatically_reload_config = true
config.check_for_updates = false
config.command_palette_font_size = 16.0
config.default_prog = { "zsh" }
config.enable_wayland = true
config.front_end = "WebGpu"
config.hide_tab_bar_if_only_one_tab = false
config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.8 }
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }
config.status_update_interval = 500
config.tab_and_split_indices_are_zero_based = false
config.tab_bar_at_bottom = true
config.tab_max_width = 15
config.unix_domains = { { name = "mux" } }
config.use_fancy_tab_bar = false
config.window_close_confirmation = "AlwaysPrompt"
config.window_decorations = "NONE"
config.window_padding = { left = 6, right = 6, top = 6, bottom = 0 }
config.ssh_domains = {
	{ name = "server", remote_address = "server", username = "phrmendes" },
	{ name = "desktop", remote_address = "linux", username = "prochame" },
}

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
	{ key = "y", mods = "LEADER", action = action.ActivateCopyMode },
	{ key = "z", mods = "LEADER", action = action.TogglePaneZoomState },
	{
		key = "R",
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
		key = "r",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extension
				local state
				if type == "workspace" then
					state = resurrect.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, {
						relative = true,
						restore_text = true,
						on_pane_restore = resurrect.tab_state.default_on_pane_restore,
					})
				elseif type == "window" then
					state = resurrect.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, {
						relative = true,
						restore_text = true,
						on_pane_restore = resurrect.tab_state.default_on_pane_restore,
						tab = win:active_tab(),
					})
				end
			end)
		end),
	},
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action_callback(function()
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
			resurrect.window_state.save_window_action()
		end),
	},
	{
		key = "w",
		mods = "LEADER",
		action = ws.switch_workspace({
			{ extra_args = " | rg " .. home .. "/(Projects|Documents/notes) | cut --delimiter '/' --fields 1-7" },
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

wezterm.on("update-status", function(window)
	local status
	local workspace = base_path(window:active_workspace())

	if workspace ~= "default" then
		status = {
			{ Text = " " },
			{ Text = nf.cod_terminal_tmux },
			{ Text = " " },
			{ Text = base_path(workspace) },
			{ Text = " " },
		}
	else
		status = { { Text = "" } }
	end

	window:set_right_status(wezterm.format(status))
end)

wezterm.on("format-tab-title", function(tab)
	local title = function(t)
		local title = t.tab_title

		if string.len(title) == 0 then
			title = t.active_pane.title
		end

		return title
	end

	local index = function(t)
		local index = t.tab_index + 1

		if index < 10 then
			return nf[string.format("md_numeric_%d_box_outline", index)]
		end

		return nf.md_numeric_9_plus_box_outline
	end

	local zoom = function(t)
		if t.active_pane.is_zoomed then
			return nf.cod_zoom_in .. " "
		end

		return ""
	end

	return {
		{ Text = " " },
		{ Text = index(tab) },
		{ Text = " " },
		{ Text = title(tab) },
		{ Text = " " },
		{ Text = zoom(tab) },
	}
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}

	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)

		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end

	window:set_config_overrides(overrides)
end)

ss.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL",
		resize = "ALT",
	},
})

ws.workspace_formatter = function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Text = nf.md_dock_window },
		{ Text = " " },
		{ Text = label },
	})
end

return config
