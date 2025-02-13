return {
	"echasnovski/mini.nvim",
	event = "VimEnter",
	version = "*",
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
		require("plugins.mini.extra")
		require("plugins.mini.git")
		require("plugins.mini.hipatterns")
		require("plugins.mini.icons")
		require("plugins.mini.indentscope")
		require("plugins.mini.jump")
		require("plugins.mini.jump2d")
		require("plugins.mini.misc")
		require("plugins.mini.move")
		require("plugins.mini.notify")
		require("plugins.mini.operators")
		require("plugins.mini.pairs")
		require("plugins.mini.pick")
		require("plugins.mini.sessions")
		require("plugins.mini.splitjoin")
		require("plugins.mini.starter")
		require("plugins.mini.statusline")
		require("plugins.mini.surround")
		require("plugins.mini.tabline")
		require("plugins.mini.test")
		require("plugins.mini.trailspace")
		require("plugins.mini.visits")
	end,
	keys = {
		{ "<c-p>", function() require("utils").mini.buffers() end, desc = "List buffers" },
		{ "<leader>/", function() require("mini.pick").builtin.grep_live() end, desc = "Live grep" },
		{ "<leader>?", function() require("mini.pick").builtin.help() end, desc = "Help" },
		{ "<leader><leader>", function() require("mini.pick").builtin.files() end, desc = "Find" },
		{ "<leader>K", function() require("mini.extra").pickers.keymaps() end, desc = "Keymaps" },
		{ "<leader>v", function() require("mini.extra").pickers.visit_paths() end, desc = "Visits" },
		{ "<leader>bd", function() require("mini.bufremove").delete() end, desc = "Delete" },
		{ "<leader>bw", function() require("mini.bufremove").wipeout() end, desc = "Wipeout" },
		{ "<leader>g.", "<cmd>Git commit<cr>", desc = "Commit" },
		{ "<leader>ga", "<cmd>Git add %<cr>", desc = "Add (file)" },
		{ "<leader>gA", "<cmd>Git add --all<cr>", desc = "Add (repo)" },
		{
			"<leader>gc",
			function() require("mini.extra").pickers.git_commits({ path = vim.fn.expand("%") }) end,
			desc = "Commits (file)",
		},
		{ "<leader>gC", function() require("mini.extra").pickers.git_commits() end, desc = "Commits (repo)" },
		{ "<leader>gd", "<cmd>Git diff %<cr>", desc = "Diff" },
		{ "<leader>gh", function() require("mini.git").show_at_cursor() end, desc = "History", mode = { "n", "v" } },
		{ "<leader>gH", function() require("mini.extra").pickers.git_hunks() end, desc = "Hunks" },
		{ "<leader>gp", "<cmd>Git pull<cr>", desc = "Pull" },
		{ "<leader>gP", "<cmd>Git push<cr>", desc = "Push" },
		{ "<leader>ll", function() require("mini.extra").pickers.visit_labels() end, desc = "List labels" },
		{
			"<leader>la",
			function()
				vim.ui.input({ prompt = "Label: " }, function(input)
					if input == "" or input == nil then
						vim.notify("Label cannot be empty", vim.log.levels.ERROR)
					else
						require("mini.visits").add_label(input)
					end
				end)
			end,
			desc = "Add label",
		},
		{
			"<leader>ld",
			function()
				vim.ui.select(
					require("mini.visits").list_labels(),
					{ prompt = "Select label: " },
					function(choosed) require("mini.visits").remove_label(choosed) end
				)
			end,
			desc = "Delete label",
		},
	},
}
