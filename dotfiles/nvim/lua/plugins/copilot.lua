require("copilot").setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
})

require("CopilotChat").setup({
	mappings = {
		complete = {
			insert = "",
		},
	},
})
