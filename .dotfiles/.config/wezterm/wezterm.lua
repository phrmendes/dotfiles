local wezterm = require("wezterm")

local config = {
	bold_brightens_ansi_colors = true,
	color_scheme = "Gruvbox dark, pale (base16)",
	default_prog = { "zsh" },
	enable_tab_bar = false,
	font_size = 12.0,
	window_decorations = "NONE",
	font = wezterm.font("JetBrains Mono", { weight = "Regular" }),
	window_padding = {
		left = 10,
		right = 10,
		top = 5,
		bottom = 5,
	},
}

return config
