local wezterm = require("wezterm")
local act = wezterm.action

local config = {
	allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
	bold_brightens_ansi_colors = true,
	color_scheme = "Catppuccin Mocha",
	default_prog = { "/home/phrmendes/.nix-profile/bin/zsh" },
	enable_tab_bar = false,
	font_size = 12.0,
	window_decorations = "NONE",
	check_for_updates = false,
	font = wezterm.font("JetBrains Mono"),
	window_padding = { left = 10, right = 10, top = 5, bottom = 5 },
	keys = {
		{
			key = "C",
			mods = "CTRL",
			action = act.CopyTo("ClipboardAndPrimarySelection"),
		},
		{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	},

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
	end),
}

return config
