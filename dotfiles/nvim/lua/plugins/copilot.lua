return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = { markdown = false, help = true },
			server = {
				type = "binary",
				custom_server_filepath = require("nix.copilot"),
			},
		},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			"zbirenbaum/copilot.lua",
			"nvim-lua/plenary.nvim",
		},
		cmd = { "CopilotChat", "CopilotChatToggle" },
		opts = {
			chat_autocomplete = true,
			selection = function(source) return require("CopilotChat.select").visual(source) end,
			question_header = "# User ",
			answer_header = "# Copilot ",
			error_header = "# Error ",
			separator = "───",
			mappings = {
				submit_prompt = { normal = "<cr>", insert = "<c-s>" },
				reset = { normal = "<leader><bs>", insert = "<c-r>" },
			},
			prompts = {
				Concise = "Rewrite the following text to make it more concise:\n",
				Documentation = "Provide documentation for the following code:\n",
				Spelling = "Correct and improve any grammar or spelling errors in the following text:\n",
				Summarize = "Summarize the following text:\n",
			},
		},
		config = function(_, opts)
			require("CopilotChat").setup(opts)

			vim.api.nvim_create_autocmd("BufEnter", {
				desc = "Options for copilot filetypes",
				group = vim.api.nvim_create_augroup("UserCopilotFileType", { clear = true }),
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end,
			})
		end,
		keys = {
			{ "<leader>c", "", desc = "+copilot", mode = { "n", "x" } },
			{ "<leader>cc", "<cmd>CopilotChat<cr>", mode = "x", desc = "Chat" },
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Chat" },
			{ "<leader>cp", "<cmd>CopilotChatPrompts<cr>", mode = { "n", "x" }, desc = "Prompts" },
		},
	},
}
