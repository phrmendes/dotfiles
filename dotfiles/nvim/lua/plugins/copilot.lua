local prompts = {
	Concise = "Rewrite the following text to make it more concise.",
	Documentation = "Provide documentation for the following code.",
	Spelling = "Correct and improve any grammar or spelling errors in the following text.",
	Summarize = "Summarize the following text.",
}

return {
	{ "github/copilot.vim", event = "InsertEnter" },
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" },
		},
		init = function()
			vim.g.copilot_filetypes = {
				["copilot-chat"] = false,
			}
		end,
		cmd = { "CopilotChat", "CopilotChatToggle" },
		opts = {
			chat_autocomplete = true,
			model = "claude-3.7-sonnet",
			prompts = prompts,
			mappings = {
				submit_prompt = { normal = "<cr>", insert = "<c-s>" },
				reset = { normal = "<leader><bs>", insert = "<c-r>" },
			},
			selection = function(source) return require("CopilotChat.select").visual(source) end,
		},
		keys = {
			{ "<leader>c", "", desc = "+copilot", mode = { "n", "x" } },
			{ "<leader>cc", "<cmd>CopilotChat<cr>", mode = "x", desc = "Chat" },
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Chat" },
			{ "<leader>cp", "<cmd>CopilotChatPrompts<cr>", mode = { "n", "x" }, desc = "Prompts" },
		},
	},
}
