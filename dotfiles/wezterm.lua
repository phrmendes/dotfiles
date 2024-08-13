local wezterm = require("wezterm")

local action = wezterm.action
local config = wezterm.config_builder()
local nf = wezterm.nerdfonts

local ss = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local ws = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local utils = {
	base_name = function(path)
		return string.gsub(path, "(.*[/\\])(.*)", "%2")
	end,
	title = function(tab, max_width)
		local title = tab.tab_title

		if string.len(title) == 0 then
			title = tab.active_pane.title
		end

		if string.len(title) + string.len(tab.tab_index) > max_width then
			title = wezterm.truncate_right(title, max_width - 5) .. "..."
		end

		return title
	end,
	index = function(tab)
		local index = tab.tab_index + 1

		if index < 10 then
			return nf[string.format("md_numeric_%d_box_outline", index)]
		end

		return nf.md_numeric_9_plus_box_outline
	end,
	zoom = function(tab)
		if tab.active_pane.is_zoomed then
			return "[" .. nf.cod_zoom_in .. "] "
		end

		return ""
	end,
	zen = function(window, pane, name, value)
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

		return overrides
	end,
}

config.check_for_updates = false
config.command_palette_font_size = 16.0
config.default_prog = { "zsh" }
config.hide_tab_bar_if_only_one_tab = false
config.inactive_pane_hsb = { saturation = 0.5, brightness = 0.7 }
config.status_update_interval = 500
config.tab_and_split_indices_are_zero_based = false
config.tab_bar_at_bottom = true
config.tab_max_width = 20
config.use_fancy_tab_bar = false
config.window_close_confirmation = "AlwaysPrompt"
config.window_padding = { left = 6, right = 6, top = 6, bottom = 0 }
config.window_decorations = "RESIZE"
config.enable_wayland = false
config.unix_domains = { { name = "mux" } }
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }
config.ssh_domains = {
	{ name = "server", remote_address = "server", username = "phrmendes" },
	{ name = "desktop", remote_address = "desktop", username = "phrmendes" },
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
	{ key = "w", mods = "LEADER", action = ws.switch_workspace() },
	{ key = "y", mods = "LEADER", action = action.ActivateCopyMode },
	{ key = "z", mods = "LEADER", action = action.TogglePaneZoomState },
	{
		key = "r",
		mods = "LEADER",
		action = action.PromptInputLine({
			description = "Rename tab:",
			action = wezterm.action_callback(function(_, pane, line)
				if line then
					pane:tab():set_title(line)
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

wezterm.on("update-status", function(window, _)
	local workspace = utils.base_name(window:active_workspace())

	window:set_left_status(wezterm.format({
		{ Text = " " },
		{ Text = nf.md_tab },
		{ Text = " " },
	}))

	if workspace ~= "default" then
		window:set_right_status(wezterm.format({
			{ Text = " " },
			{ Text = nf.cod_terminal_tmux },
			{ Text = " " },
			{ Text = workspace },
			{ Text = " " },
		}))
	else
		window:set_right_status(wezterm.format({
			{ Text = "" },
		}))
	end
end)

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	return {
		{ Text = " " },
		{ Text = utils.index(tab) },
		{ Text = " " },
		{ Text = utils.title(tab, max_width) },
		{ Text = " " },
		{ Text = utils.zoom(tab) },
	}
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
	window:set_config_overrides(utils.zen(window, pane, name, value))
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, _, label)
	resurrect.workspace_state.restore_workspace(resurrect.load_state(label, "workspace"), {
		window = window,
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	})
end)

wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function()
	resurrect.save_state(resurrect.workspace_state.get_workspace_state())
end)

ss.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL",
		resize = "ALT",
	},
})

ws.set_workspace_formatter(function(label)
	return wezterm.format({
		{ Text = nf.md_dock_window .. " : " .. label },
	})
end)

resurrect.periodic_save()

return config
