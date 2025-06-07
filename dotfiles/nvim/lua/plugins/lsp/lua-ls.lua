return {
	settings = {
		Lua = {
			completion = { callSnippet = "Replace" },
			telemetry = { enable = false },
			globals = { "vim", "Snacks" },
			diagnostics = { disable = { "missing-fields" } },
		},
	},
}
