local wezterm = require("wezterm")
local act = wezterm.action
local home = os.getenv("HOME")

local config = {
	allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
	bold_brightens_ansi_colors = true,
	check_for_updates = false,
	color_scheme = "Catppuccin Mocha",
	default_prog = { home .. "/.nix-profile/bin/zsh" },
	enable_tab_bar = false,
	font = wezterm.font("JetBrains Mono"),
	font_size = 12.0,
	window_decorations = "NONE",
	window_padding = { left = 10, right = 10, top = 5, bottom = 5 },
	keys = {
		{
			key = "C",
			mods = "CTRL",
			action = act.CopyTo("ClipboardAndPrimarySelection"),
		},
		{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	},
}

return config
