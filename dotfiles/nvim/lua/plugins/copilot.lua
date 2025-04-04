local prompts = {
	Explain = "Please explain how the following code works.",
	Review = "Please review the following code and provide suggestions for improvement.",
	Tests = "Please explain how the selected code works, then generate unit tests for it.",
	Refactor = "Please refactor the following code to improve its clarity and readability.",
	FixCode = "Please fix the following code to make it work as intended.",
	FixError = "Please explain the error in the following text and provide a solution.",
	BetterNamings = "Please provide better names for the following variables and functions.",
	Documentation = "Please provide documentation for the following code.",
	Summarize = "Please summarize the following text.",
	Spelling = "Please correct any grammar and spelling errors in the following text.",
	Wording = "Please improve the grammar and wording of the following text.",
	Concise = "Please rewrite the following text to make it more concise.",
}

return {
	{
		"github/copilot.vim",
		event = "InsertEnter",
		cmd = "Copilot",
	},
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
			model = "claude-3.5-sonnet",
			prompts = prompts,
			mappings = {
				submit_prompt = { normal = "<cr>", insert = "<c-s>" },
				reset = { normal = "<leader><bs>", insert = "<c-r>" },
			},
			selection = function(source) return require("CopilotChat.select").visual(source) end,
		},
		keys = {
			{ "<leader>cc", "<cmd>CopilotChat<cr>", mode = "v", desc = "Chat" },
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Chat" },
			{ "<leader>cp", function() require("CopilotChat").select_prompt() end, mode = { "n", "v" }, desc = "Prompts" },
		},
	},
}
