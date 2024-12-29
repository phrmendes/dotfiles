require("CopilotChat").setup({
	chat_autocomplete = true,
	mappings = {
		reset = {
			normal = "<leader>r",
			insert = "<c-r>",
		},
	},
})

vim.g.copilot_filetypes = {
	["copilot-chat"] = false,
	minifiles = false,
}
