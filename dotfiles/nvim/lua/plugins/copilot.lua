require("copilot").setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
})

require("CopilotChat").setup({
	chat_autocomplete = true,
	mappings = {
		reset = {
			normal = "<leader>r",
			insert = "<c-r>",
		},
	},
})
