MiniDeps.later(function()
	MiniDeps.add({ source = "zbirenbaum/copilot.lua" })

	require("copilot").setup({
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = true,
			keymap = {
				accept = "<c-l>",
				next = "<c-right>",
				prev = "<c-left>",
				dismiss = "<c-e>",
			},
		},
		server = {
			type = "binary",
			custom_server_filepath = require("nix.copilot"),
		},
	})
end)
