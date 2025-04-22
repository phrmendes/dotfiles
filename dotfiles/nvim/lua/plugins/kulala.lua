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
			["kulala: show headers"] = { "H", function() require("kulala.ui").show_headers() end },
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
		{
			"<leader>R",
			function() require("kulala").scratchpad() end,
			desc = "kulala: scratchpad",
		},
		{
			"<localleader>S",
			function() require("kulala").show_stats() end,
			ft = "http",
			desc = "kulala: statistics",
		},
		{
			"<localleader>a",
			function() require("kulala").run_all() end,
			mode = { "n", "x" },
			desc = "kulala: send all",
			ft = "http",
		},
		{
			"<localleader>c",
			function() require("kulala").copy() end,
			ft = "http",
			desc = "kulala: copy as a curl command",
		},
		{
			"<localleader>f",
			function() require("kulala").from_curl() end,
			ft = "http",
			desc = "kulala: paste curl from clipboard",
		},
		{
			"<localleader>i",
			function() require("kulala").inspect() end,
			ft = "http",
			desc = "kulala: inspect",
		},
		{
			"<localleader>l",
			function() require("kulala").replay() end,
			ft = "http",
			desc = "kulala: replay",
		},
		{
			"<localleader>q",
			function() require("kulala").close() end,
			ft = "http",
			desc = "kulala: close",
		},
		{
			"<localleader>s",
			function() require("kulala").run() end,
			mode = { "n", "x" },
			ft = "http",
			desc = "kulala: send",
		},
		{
			"<localleader>t",
			function() require("kulala").toggle_view() end,
			ft = "http",
			desc = "kulala: toggle between body and headers",
		},
	},
}
