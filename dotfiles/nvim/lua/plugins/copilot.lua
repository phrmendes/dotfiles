return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "github/copilot.vim" },
		{ "nvim-lua/plenary.nvim", branch = "master" },
	},
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
		{ mode = "v", "<leader>cc", "<cmd>CopilotChat<cr>", desc = "Quick chat" },
		{ mode = { "n", "v" }, "<leader>cR", "<cmd>CopilotChatReview<cr>", desc = "Review" },
		{ mode = { "n", "v" }, "<leader>cT", "<cmd>CopilotChatTests<cr>", desc = "Generate tests" },
		{ mode = { "n", "v" }, "<leader>cd", "<cmd>CopilotChatDocs<cr>", desc = "Generate docs" },
		{ mode = { "n", "v" }, "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Explain" },
		{ mode = { "n", "v" }, "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Fix" },
		{ mode = { "n", "v" }, "<leader>co", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize" },
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
}
