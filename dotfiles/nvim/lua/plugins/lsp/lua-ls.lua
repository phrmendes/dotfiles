return {
	settings = {
		Lua = {
			completion = { callSnippet = "Replace" },
			diagnostics = {
				globals = { "vim", "_" },
				disable = { "missing-fields" },
			},
			telemetry = { enable = false },
		},
	},
}
