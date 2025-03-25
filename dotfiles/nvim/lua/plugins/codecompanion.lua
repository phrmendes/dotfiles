return {
	"olimorris/codecompanion.nvim",
	cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		strategies = {
			chat = {
				adapter = "deepseek",
			},
			inline = {
				adapter = "deepseek",
			},
			cmd = {
				adapter = "deepseek",
			},
		},
		adapters = {
			deepseek = function()
				return require("codecompanion.adapters").extend("deepseek", {
					env = {
						api_key = "cmd:bw get notes 47019f86-c3f1-47d9-ac53-b2ab000e0c96",
					},
					schema = {
						model = {
							default = "deepseek-coder",
						},
					},
				})
			end,
		},
	},
	keys = {
		{
			"<leader>c",
			"<cmd>CodeCompanionActions<cr>",
			desc = "CodeCompanion",
		},
	},
}
