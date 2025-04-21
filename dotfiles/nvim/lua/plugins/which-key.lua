return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		icons = {
			mappings = false,
			group = "",
		},
		spec = {
			{ "<leader><tab>", group = "tabs" },
			{ "<leader>b", group = "buffers" },
			{ "<leader>c", group = "copilot" },
			{ "<leader>g", group = "git" },
			{ "<leader>n", group = "notes" },
			{ "<leader>t", group = "todo.txt" },
			{ "<localleader>", group = "," },
			{ "<localleader>g", group = "go" },
			{ "<localleader>p", group = "python" },
		},
	},
}
