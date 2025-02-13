return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		input = { enabled = true },
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		words = { enabled = true },
		lazygit = { configure = false },
		terminal = { win = { wo = { winbar = "" } } },
		statuscolumn = {
			enabled = true,
			git = { patterns = { "MiniDiffSign" } },
		},
		explorer = { replace_netrw = true },
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				_G.dd = function(...) require("snacks").debug.inspect(...) end

				_G.bt = function() require("snacks").debug.backtrace() end

				vim.print = _G.dd
			end,
		})
	end,
	keys = {
		{ mode = { "n", "t" }, "<c-\\>", function() require("snacks").terminal() end, desc = "Toggle Terminal" },
		{ "<leader>Z", function() require("snacks").zen.zoom() end, desc = "Zoom" },
		{ "<leader>gb", function() require("snacks").git.blame_line() end, desc = "Blame line" },
		{ "<leader>gg", function() require("snacks").lazygit() end, desc = "LazyGit" },
		{ "<leader>go", function() require("snacks").gitbrowse() end, desc = "Open in browser" },
		{ "<leader>z", function() require("snacks").zen() end, desc = "Zen" },
		{ "<leader>e", function() require("snacks").explorer() end, desc = "Explorer" },
	},
}
