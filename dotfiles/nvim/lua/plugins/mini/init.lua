return {
	"echasnovski/mini.nvim",
	event = "VimEnter",
	dependencies = { "rafamadriz/friendly-snippets", "folke/snacks.nvim" },
	config = function()
		require("plugins.mini.ai")
		require("plugins.mini.align")
		require("plugins.mini.base16")
		require("plugins.mini.bracketed")
		require("plugins.mini.bufremove")
		require("plugins.mini.clue")
		require("plugins.mini.comment")
		require("plugins.mini.completion")
		require("plugins.mini.cursorword")
		require("plugins.mini.diff")
		require("plugins.mini.doc")
		require("plugins.mini.files")
		require("plugins.mini.git")
		require("plugins.mini.hipatterns")
		require("plugins.mini.icons")
		require("plugins.mini.indentscope")
		require("plugins.mini.jump")
		require("plugins.mini.jump2d")
		require("plugins.mini.keymap")
		require("plugins.mini.misc")
		require("plugins.mini.move")
		require("plugins.mini.notify")
		require("plugins.mini.operators")
		require("plugins.mini.pairs")
		require("plugins.mini.pick")
		require("plugins.mini.sessions")
		require("plugins.mini.snippets")
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
		{ "<leader>/", function() require("mini.pick").builtin.grep_live() end, desc = "Live grep" },
		{ "<leader>:", function() require("mini.extra").pickers.commands() end, desc = "Command history" },
		{ "<leader>?", function() require("mini.pick").builtin.help() end, desc = "Help" },
		{
			"<leader>.",
			function()
				local mode = vim.api.nvim_get_mode().mode

				if mode == "n" then
					require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") })
					return
				end

				local v_start = vim.fn.getpos(".")
				local v_end = vim.fn.getpos("v")
				local region = table.concat(vim.fn.getregion(v_start, v_end)):gsub("\t", "")

				require("mini.pick").builtin.grep({ pattern = region })
			end,
			mode = { "n", "x" },
			desc = "Grep word",
		},
		{ "<leader><leader>", function() require("mini.pick").builtin.files() end, desc = "Find" },
		{ "<leader><del>", function() require("mini.notify").clear() end, desc = "Dismiss notifications" },
		{ "<leader>A", function() require("mini.test").run() end, desc = "mini: run all tests", ft = "lua" },
		{ "<leader>E", function() require("mini.files").open(vim.fs.root(0, ".git"), true) end, desc = "Explorer (cwd)" },
		{ "<leader>G", function() require("mini.doc").generate() end, desc = "mini: generate docs", ft = "lua" },
		{ "<leader>N", function() require("mini.notify").show_history() end, desc = "Notifications" },
		{ "<leader>T", function() require("mini.test").run_at_location() end, desc = "mini: run tests", ft = "lua" },
		{
			"<leader>bb",
			function()
				require("mini.pick").builtin.buffers(nil, {
					mappings = {
						wipeout = {
							char = "<c-d>",
							func = function() vim.api.nvim_buf_delete(require("mini.pick").get_picker_matches().current.bufnr, {}) end,
						},
					},
				})
			end,
			desc = "List",
		},
		{ "<leader>bd", function() require("mini.bufremove").delete() end, desc = "Delete" },
		{ "<leader>bw", function() require("mini.bufremove").wipeout() end, desc = "Wipeout" },
		{
			"<leader>e",
			function()
				if not require("mini.files").close() then
					local path = vim.fn.expand("%:p:h")

					if vim.uv.fs_stat(path) then
						require("mini.files").open(path, true)
						return
					end

					require("mini.files").open(nil, true)
				end
			end,
			desc = "Explorer",
		},
		{ "<leader>gA", "<cmd>Git add --all<cr>", desc = "Add (repo)" },
		{ "<leader>gL", function() require("mini.extra").pickers.git_commits() end, desc = "Log (repo)" },
		{ "<leader>gP", "<cmd>Git push<cr>", desc = "Push" },
		{ "<leader>ga", "<cmd>Git add %<cr>", desc = "Add (file)" },
		{ "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
		{ "<leader>gd", function() require("mini.diff").toggle_overlay(0) end, desc = "Diff (file)" },
		{ "<leader>gh", function() require("mini.extra").pickers.git_hunks() end, desc = "Hunks" },
		{ "<leader>gp", "<cmd>Git pull<cr>", desc = "Pull" },
		{ "<leader>gl", function() require("mini.extra").pickers.git_commits() end, desc = "Log (file)" },
		{
			"<leader>gs",
			function() require("mini.git").show_at_cursor({ split = "horizontal" }) end,
			desc = "Show at cursor",
			mode = { "n", "x" },
		},
		{ "<leader>K", function() require("mini.extra").pickers.keymaps() end, desc = "Keymaps" },
		{ "<leader>ll", function() require("mini.extra").pickers.visit_labels() end, desc = "List" },
		{
			"<leader>la",
			function()
				vim.ui.input({ prompt = "Label: " }, function(input)
					if input == "" or input == nil then
						vim.notify("Label cannot be empty", vim.log.levels.ERROR)
						return
					end

					require("mini.visits").add_label(input)
				end)
			end,
			desc = "Add",
		},
		{
			"<leader>ld",
			function()
				vim.ui.select(require("mini.visits").list_labels(), { prompt = "Select label: " }, function(input)
					if input == "" or input == nil then
						vim.notify("Label cannot be empty", vim.log.levels.ERROR)
						return
					end

					require("mini.visits").remove_label(input)
				end)
			end,
			desc = "Delete",
		},
		{ "<leader>m", function() require("mini.extra").pickers.marks() end, desc = "Marks" },
		{ "<leader>v", function() require("mini.extra").pickers.visit_paths() end, desc = "Visits" },
	},
}
