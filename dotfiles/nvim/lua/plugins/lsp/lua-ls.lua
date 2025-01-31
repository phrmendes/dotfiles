return {
	settings = {
		Lua = {
			completion = { callSnippet = "Replace" },
			diagnostics = {
				globals = { "vim", "_", "_G" },
				disable = { "missing-fields" },
			},
			telemetry = { enable = false },
		},
	},
}
