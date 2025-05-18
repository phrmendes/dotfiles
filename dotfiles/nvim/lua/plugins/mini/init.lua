return {
	"echasnovski/mini.nvim",
	event = "VimEnter",
	config = function()
		require("plugins.mini.ai")
		require("plugins.mini.align")
		require("plugins.mini.base16")
		require("plugins.mini.bracketed")
		require("plugins.mini.bufremove")
		require("plugins.mini.clue")
		require("plugins.mini.comment")
		require("plugins.mini.cursorword")
		require("plugins.mini.diff")
		require("plugins.mini.doc")
		require("plugins.mini.git")
		require("plugins.mini.hipatterns")
		require("plugins.mini.icons")
		require("plugins.mini.indentscope")
		require("plugins.mini.jump")
		require("plugins.mini.jump2d")
		require("plugins.mini.keymap")
		require("plugins.mini.misc")
		require("plugins.mini.move")
		require("plugins.mini.operators")
		require("plugins.mini.pairs")
		require("plugins.mini.sessions")
		require("plugins.mini.splitjoin")
		require("plugins.mini.starter")
		require("plugins.mini.statusline")
		require("plugins.mini.surround")
		require("plugins.mini.tabline")
		require("plugins.mini.test")
		require("plugins.mini.trailspace")
	end,
	keys = {
		{ "<leader>A", function() require("mini.test").run() end, desc = "mini: run all tests", ft = "lua" },
		{ "<leader>G", function() require("mini.doc").generate() end, desc = "mini: generate docs", ft = "lua" },
		{ "<leader>T", function() require("mini.test").run_at_location() end, desc = "mini: run tests", ft = "lua" },
		{ "<leader>bd", function() require("mini.bufremove").delete() end, desc = "Delete" },
		{ "<leader>bw", function() require("mini.bufremove").wipeout() end, desc = "Wipeout" },
		{ "<leader>gA", "<cmd>Git add --all<cr>", desc = "Add (repo)" },
		{ "<leader>gP", "<cmd>Git push<cr>", desc = "Push" },
		{ "<leader>ga", "<cmd>Git add %<cr>", desc = "Add (file)" },
		{ "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
		{ "<leader>gp", "<cmd>Git pull<cr>", desc = "Pull" },
		{ "<leader>gd", function() require("mini.diff").toggle_overlay(0) end, desc = "Diff (file)" },
		{
			"<leader>gs",
			function() require("mini.git").show_at_cursor({ split = "horizontal" }) end,
			desc = "Show at cursor",
			mode = { "n", "x" },
		},
	},
}
