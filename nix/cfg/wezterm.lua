local wezterm = require("wezterm")
local act = wezterm.action

local config = {
	allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
	bold_brightens_ansi_colors = true,
	color_scheme = "Catppuccin Macchiato",
	default_prog = { "$HOME/.nix-profile/bin/zsh" },
	enable_tab_bar = false,
	font_size = 12.0,
	window_decorations = "NONE",
	font = wezterm.font("JetBrains Mono"),
	window_padding = {
		left = 10,
		right = 10,
		top = 5,
		bottom = 5,
	},
	keys = {
		{ key = "C", mods = "CTRL", action = act.CopyTo("ClipboardAndPrimarySelection") },
		{ key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
	},
}

return config
