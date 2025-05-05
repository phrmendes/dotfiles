return {
	"mistweaverco/kulala.nvim",
	ft = "http",
	opts = {
		icons = {
			inlay = {
				done = "",
				error = "󰅚",
				loading = "",
			},
		},
		kulala_keymaps = {
			["show headers"] = { "H", function() require("kulala.ui").show_headers() end },
		},
		contenttypes = {
			["application/json"] = {
				ft = "json",
			},
			["application/xml"] = {
				ft = "xml",
			},
			["text/html"] = {
				ft = "html",
			},
		},
	},
	keys = {
		{ "<localleader>k", "", desc = "+kulala" },
		{ "<localleader>ks", function() require("kulala").scratchpad() end, desc = "Scratchpad" },
		{ "<localleader>kS", function() require("kulala").show_stats() end, desc = "Statistics", ft = "http" },
		{ "<localleader>kc", function() require("kulala").copy() end, desc = "Copy as a curl command", ft = "http" },
		{ "<localleader>ki", function() require("kulala").inspect() end, desc = "Inspect", ft = "http" },
		{ "<localleader>kr", function() require("kulala").replay() end, desc = "Replay", ft = "http" },
		{ "<localleader>kq", function() require("kulala").close() end, desc = "Close", ft = "http" },
		{ "<localleader>kk", function() require("kulala").run() end, mode = { "n", "x" }, desc = "Send", ft = "http" },
		{
			"<localleader>kf",
			function() require("kulala").from_curl() end,
			desc = "Paste curl from clipboard",
			ft = "http",
		},
		{
			"<localleader>ka",
			function() require("kulala").run_all() end,
			desc = "Send all",
			ft = "http",
			mode = { "n", "x" },
		},
		{
			"<localleader>kt",
			function() require("kulala").toggle_view() end,
			desc = "Toggle between body and headers",
			ft = "http",
		},
	},
}
