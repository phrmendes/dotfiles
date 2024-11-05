local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action
local nf = wezterm.nerdfonts
local mux = wezterm.mux

local ss = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local ws = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local rr = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local get_base_path = function(path)
	return path:gsub("(.*[/\\])(.*)", "%2")
end

local remove_file_extension = function(file)
	return file:gsub("(.+)%..+$", "%1")
end

config.automatically_reload_config = true
config.check_for_updates = false
config.command_palette_font_size = 16.0
config.default_prog = { "zsh" }
config.enable_wayland = false
config.front_end = "WebGpu"
config.hide_tab_bar_if_only_one_tab = false
config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.8 }
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
config.pane_focus_follows_mouse = true
config.scrollback_lines = 5000
config.status_update_interval = 500
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_and_split_indices_are_zero_based = false
config.tab_bar_at_bottom = true
config.tab_max_width = 100
config.unix_domains = { { name = "unix" } }
config.use_fancy_tab_bar = false
config.window_close_confirmation = "AlwaysPrompt"
config.window_decorations = "NONE"
config.window_padding = { left = 6, right = 6, top = 6, bottom = 0 }
config.ssh_domains = {
	{ name = "desktop", remote_address = "desktop", username = "phrmendes" },
	{ name = "laptop", remote_address = "laptop", username = "phrmendes" },
	{ name = "orangepizero2", remote_address = "orangepizero2", username = "phrmendes" },
}

config.keys = {
	{ key = "Space", mods = "LEADER|CTRL", action = action.SendKey({ key = "Space", mods = "CTRL" }) },
	{ key = "Enter", mods = "LEADER", action = action.SpawnWindow },
	{ key = "'", mods = "LEADER", action = action.PaneSelect({ mode = "SwapWithActiveKeepFocus" }) },
	{ key = "-", mods = "LEADER", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "[", mods = "LEADER", action = action.ActivateTabRelative(-1) },
	{ key = "\\", mods = "LEADER", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "]", mods = "LEADER", action = action.ActivateTabRelative(1) },
	{ key = "{", mods = "LEADER", action = action.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER", action = action.MoveTabRelative(1) },
	{ key = ".", mods = "LEADER", action = action.RotatePanes("Clockwise") },
	{ key = ",", mods = "LEADER", action = action.RotatePanes("CounterClockwise") },
	{ key = "Q", mods = "LEADER", action = action.CloseCurrentTab({ confirm = true }) },
	{ key = "a", mods = "LEADER", action = action.AttachDomain("unix") },
	{ key = "d", mods = "LEADER", action = action.DetachDomain({ DomainName = "unix" }) },
	{ key = "l", mods = "LEADER", action = action.ShowLauncherArgs({ flags = "FUZZY|DOMAINS" }) },
	{ key = "n", mods = "LEADER", action = action.SpawnTab("CurrentPaneDomain") },
	{ key = "p", mods = "LEADER", action = action.ActivateCommandPalette },
	{ key = "q", mods = "LEADER", action = action.CloseCurrentPane({ confirm = true }) },
	{ key = "t", mods = "LEADER", action = action.ShowTabNavigator },
	{ key = "w", mods = "LEADER", action = action.ShowLauncherArgs({ flags = "WORKSPACES" }) },
	{ key = "w", mods = "LEADER", action = ws.switch_workspace(" | rg -v 'venv|git|persist'") },
	{ key = "y", mods = "LEADER", action = action.ActivateCopyMode },
	{ key = "z", mods = "LEADER", action = action.TogglePaneZoomState },
	{
		key = "R",
		mods = "LEADER",
		action = action.PromptInputLine({
			description = "Rename session: ",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Rename tab:",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		key = "r",
		mods = "LEADER|CTRL",
		action = wezterm.action_callback(function(win, pane)
			rr.fuzzy_load(win, pane, function(id)
				id = get_base_path(id)
				id = remove_file_extension(id)

				local state = rr.load_state(id, "workspace")

				rr.workspace_state.restore_workspace(state, {
					relative = true,
					restore_text = true,
					on_pane_restore = rr.tab_state.default_on_pane_restore,
				})
			end)
		end),
	},
	{
		key = "s",
		mods = "LEADER|CTRL",
		action = wezterm.action_callback(function()
			rr.save_state(rr.workspace_state.get_workspace_state())
			rr.periodic_save()
		end),
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
	local workspace = get_base_path(window:active_workspace())

	if workspace ~= "default" then
		status = {
			{ Text = " " },
			{ Text = nf.cod_terminal_tmux },
			{ Text = " " },
			{ Text = get_base_path(workspace) },
			{ Text = " " },
		}
	else
		status = { { Text = "" } }
	end

	window:set_right_status(wezterm.format(status))
end)

wezterm.on("format-tab-title", function(tab)
	local title = function(t)
		local title

		if title and #title > 0 then
			title = t.tab_title
		end

		title = t.active_pane.title

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
			return " " .. nf.cod_zoom_in
		end

		return ""
	end

	return {
		{ Text = " " },
		{ Text = index(tab) },
		{ Text = zoom(tab) },
		{ Text = " " },
		{ Text = title(tab) },
		{ Text = " " },
	}
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
