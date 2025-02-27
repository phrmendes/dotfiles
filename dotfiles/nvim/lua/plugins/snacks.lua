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
		image = { enabled = true },
		explorer = { replace_netrw = true },
		notifier = { enabled = true },
		picker = {
			enabled = true,
			ui_select = true,
			db = {
				sqlite3_path = vim.fn.exepath("sqlite3"),
			},
		},
		statuscolumn = {
			enabled = true,
			git = { patterns = { "MiniDiffSign" } },
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				_G.dd = function(...) Snacks.debug.inspect(...) end

				_G.bt = function() Snacks.debug.backtrace() end

				vim.print = _G.dd
			end,
		})
	end,
	keys = {
		{ "<leader><space>", function() Snacks.picker.smart() end, desc = "Search" },
		{ "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
		{ "<leader>:", function() Snacks.picker.command_history() end, desc = "Command history" },
		{ "<leader>?", function() Snacks.picker.help() end, desc = "Help" },
		{ "<leader>H", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
		{ "<leader>K", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
		{ "<leader>N", function() Snacks.notifier.show_history() end, desc = "Show notification history" },
		{ "<leader>Z", function() Snacks.zen() end, desc = "Zen" },
		{ "<leader>z", function() Snacks.zen.zoom() end, desc = "Zoom" },
		{ "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
		{ "<leader>m", function() Snacks.picker.marks() end, desc = "Marks" },
		{ "<leader>u", function() Snacks.picker.undo() end, desc = "Undo history" },
		{ "<leader>gL", function() Snacks.picker.git_log() end, desc = "Log (repo)" },
		{ "<leader>gb", function() Snacks.git.blame_line() end, desc = "Blame line" },
		{ "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Diff" },
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "LazyGit" },
		{ "<leader>gl", function() Snacks.picker.git_log_file() end, desc = "Log (file)" },
		{ "<leader>go", function() Snacks.gitbrowse() end, desc = "Open in browser" },
		{ "<c-\\>", function() Snacks.terminal() end, mode = { "n", "t" }, desc = "Toggle Terminal" },
		{ "<leader>.", function() Snacks.picker.grep_word() end, mode = { "n", "x" }, desc = "Grep word" },
	},
}
