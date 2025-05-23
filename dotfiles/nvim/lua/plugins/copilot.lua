return {
	{
		"github/copilot.vim",
		event = "InsertEnter",
		init = function() vim.g.copilot_filetypes = { ["copilot-chat"] = false } end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" },
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
				group = vim.api.nvim_create_augroup("UserCopilotFiletype", { clear = true }),
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
