return {
	{
		"github/copilot.vim",
		event = "InsertEnter",
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		cmd = { "CopilotChat" },
		init = function()
			vim.g.copilot_filetypes = {
				["copilot-chat"] = false,
			}
		end,
		opts = {
			chat_autocomplete = true,
			mappings = {
				reset = {
					normal = "<leader>r",
					insert = "<c-r>",
				},
			},
		},
		keys = {
			{ "<leader>cr", "<cmd>CopilotChatReset<cr>", desc = "Reset chat" },
			{ "<leader>cs", "<cmd>CopilotChatStop<cr>", desc = "Stop chat" },
			{ "<leader>ct", "<cmd>CopilotChatToggle<cr>", desc = "Toogle chat" },
			{ "<leader>cc", "<cmd>CopilotChat<cr>", mode = "v", desc = "Quick chat" },
			{ "<leader>cR", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Review" },
			{ "<leader>cT", "<cmd>CopilotChatTests<cr>", desc = "Generate tests", mode = { "n", "v" } },
			{ "<leader>cd", "<cmd>CopilotChatDocs<cr>", mode = { "n", "v" }, desc = "Generate docs" },
			{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Explain" },
			{ "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Fix" },
			{ "<leader>co", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "Optimize" },
			{
				"<leader>cc",
				function()
					vim.ui.input({ prompt = "Quick Chat: " }, function(input)
						if input ~= "" then
							require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
						else
							vim.notify("Chat cannot be empty", vim.log.levels.ERROR)
						end
					end)
				end,
				desc = "Quick chat",
			},
		},
	},
}
