local now, later = MiniDeps.now, MiniDeps.later

MiniDeps.add({
	source = "nvim-mini/mini.nvim",
	depends = {
		"folke/snacks.nvim",
		"nvim-treesitter/nvim-treesitter",
		"rafamadriz/friendly-snippets",
	},
})

now(function() require("mini.sessions").setup() end)
now(function() require("mini.statusline").setup() end)
now(function() require("mini.tabline").setup() end)

now(function()
	require("mini.icons").setup()

	later(MiniIcons.tweak_lsp_kind)
	later(MiniIcons.mock_nvim_web_devicons)
end)

now(function()
	require("mini.base16").setup({
		palette = require("nix.base16").palette,
		use_cterm = true,
	})
end)

now(
	function()
		require("mini.bracketed").setup({
			file = { suffix = "" },
			comment = { suffix = "" },
			diagnostic = { options = { float = false } },
		})
	end
)

now(
	function()
		require("mini.starter").setup({
			evaluate_single = true,
			items = {
				require("mini.starter").sections.sessions(5, true),
				require("mini.starter").sections.recent_files(5, true),
				require("mini.starter").sections.recent_files(5, false),
				require("mini.starter").sections.builtin_actions(),
			},
			content_hooks = {
				require("mini.starter").gen_hook.adding_bullet(),
				require("mini.starter").gen_hook.indexing("all", { "Builtin actions" }),
				require("mini.starter").gen_hook.aligning("center", "center"),
			},
		})
	end
)

now(function()
	require("mini.notify").setup({
		window = { config = { border = vim.g.border } },
		content = {
			sort = function(array)
				local to_filter = { "Diagnosing", "Processing files", "file to analyze", "ltex" }

				array = vim.iter(to_filter):fold(array, function(table, filter)
					return vim
						.iter(table)
						:filter(function(notification) return not string.find(notification.msg, filter) end)
						:totable()
				end)

				return MiniNotify.default_sort(array)
			end,
		},
	})

	vim.notify = MiniNotify.make_notify()

	vim.keymap.set("n", "<leader>N", function() MiniNotify.show_history() end, { desc = "Notifications" })
	vim.keymap.set("n", "<leader><del>", function() MiniNotify.clear() end, { desc = "Clear notifications" })
end)

later(function() require("mini.align").setup() end)
later(function() require("mini.cmdline").setup() end)
later(function() require("mini.comment").setup() end)
later(function() require("mini.cursorword").setup() end)
later(function() require("mini.doc").setup() end)
later(function() require("mini.indentscope").setup({ symbol = "│" }) end)
later(function() require("mini.jump").setup() end)
later(function() require("mini.operators").setup({ replace = { prefix = "gR", reindent_linewise = true } }) end)
later(function() require("mini.pairs").setup({ modes = { insert = true, command = true, terminal = true } }) end)
later(function() require("mini.splitjoin").setup({ mappings = { toggle = "T" } }) end)
later(function() require("mini.test").setup() end)
later(function() require("mini.trailspace").setup() end)
later(function() require("mini.visits").setup() end)

later(function()
	require("mini.ai").setup({
		n_lines = 500,
		custom_textobjects = {
			B = require("mini.extra").gen_ai_spec.buffer(),
			D = require("mini.extra").gen_ai_spec.diagnostic(),
			I = require("mini.extra").gen_ai_spec.indent(),
			L = require("mini.extra").gen_ai_spec.line(),
			N = require("mini.extra").gen_ai_spec.number(),
			t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
			u = require("mini.ai").gen_spec.function_call(),
			f = require("mini.ai").gen_spec.treesitter({
				a = "@function.outer",
				i = "@function.inner",
			}),
			c = require("mini.ai").gen_spec.treesitter({
				a = "@class.outer",
				i = "@class.inner",
			}),
			o = require("mini.ai").gen_spec.treesitter({
				a = { "@block.outer", "@conditional.outer", "@loop.outer" },
				i = { "@block.inner", "@conditional.inner", "@loop.inner" },
			}),
		},
	})
end)

later(function()
	require("mini.bufremove").setup()

	vim.keymap.set("n", "<leader>bd", function() MiniBufremove.delete() end, { desc = "Delete" })
	vim.keymap.set("n", "<leader>bw", function() MiniBufremove.wipeout() end, { desc = "Wipeout" })
end)

later(function()
	require("mini.clue").setup({
		triggers = {
			-- leader triggers
			{ mode = "n", keys = "<leader>" },
			{ mode = "x", keys = "<leader>" },
			-- local leader triggers
			{ mode = "n", keys = "<localleader>" },
			{ mode = "x", keys = "<localleader>" },
			-- built-in completion
			{ mode = "i", keys = "<c-x>" },
			-- `g` key
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },
			-- `s` key
			{ mode = "n", keys = "s" },
			{ mode = "x", keys = "s" },
			-- marks
			{ mode = "n", keys = "'" },
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },
			-- registers
			{ mode = "n", keys = '"' },
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<c-r>" },
			{ mode = "c", keys = "<c-r>" },
			-- window commands
			{ mode = "n", keys = "<c-w>" },
			-- `z` key
			{ mode = "n", keys = "z" },
			{ mode = "x", keys = "z" },
		},
		clues = {
			require("mini.clue").gen_clues.builtin_completion(),
			require("mini.clue").gen_clues.g(),
			require("mini.clue").gen_clues.marks(),
			require("mini.clue").gen_clues.registers(),
			require("mini.clue").gen_clues.square_brackets(),
			require("mini.clue").gen_clues.windows(),
			require("mini.clue").gen_clues.z(),
			{ mode = "n", keys = "<leader><tab>", desc = "+tabs" },
			{ mode = "n", keys = "<leader>b", desc = "+buffers" },
			{ mode = "n", keys = "<leader>g", desc = "+git" },
			{ mode = "n", keys = "<leader>k", desc = "+kulala" },
			{ mode = "n", keys = "<leader>n", desc = "+notes" },
			{ mode = "n", keys = "<leader>o", desc = "+opencode" },
			{ mode = "n", keys = "<leader>t", desc = "+todotxt" },
			{ mode = "n", keys = "<leader>y", desc = "+yank" },
			{ mode = "x", keys = "<leader>g", desc = "+git" },
			{ mode = "x", keys = "<leader>o", desc = "+opencode" },
			{ mode = "x", keys = "<leader>y", desc = "+yank" },
		},
		window = {
			delay = 500,
			config = {
				width = "auto",
				border = vim.g.border,
			},
		},
	})
end)

later(function()
	require("mini.completion").setup({
		window = {
			info = { height = 25, width = 80, border = vim.g.border },
			signature = { height = 25, width = 80, border = vim.g.border },
		},
		fallback_action = "<c-n>",
		lsp_completion = {
			source_func = "omnifunc",
			auto_setup = false,
			process_items = function(items, base)
				return MiniCompletion.default_process_items(items, base, { kind_priority = { Text = -1, Snippet = 99 } })
			end,
		},
		mappings = {
			force_twostep = "<c-f>",
			force_fallback = "<a-f>",
			scroll_down = "<c-d>",
			scroll_up = "<c-u>",
		},
	})

	vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })

	vim.api.nvim_create_autocmd("FileType", {
		desc = "Disable completion in certain filetypes",
		pattern = { "dap-view", "dap-view-term", "dap-repl", "snacks_input", "minifiles", "grug-far" },
		callback = function(event) vim.b[event.buf].minicompletion_disable = true end,
	})
end)

later(function()
	require("mini.diff").setup({ view = { style = "sign" }, signs = { add = "█", change = "▒", delete = "" } })

	vim.keymap.set("n", "<leader>gd", function() MiniDiff.toggle_overlay(0) end, { desc = "Diff (file)" })
end)

later(function()
	require("mini.extra").setup()

	vim.keymap.set("n", "<leader>:", function() MiniExtra.pickers.history({ scope = ":" }) end, { desc = "`:` history" })
	vim.keymap.set("n", "<leader>K", function() MiniExtra.pickers.keymaps() end, { desc = "Keymaps" })
	vim.keymap.set("n", "<leader>m", function() MiniExtra.pickers.marks() end, { desc = "Marks" })
	vim.keymap.set("n", "<leader>v", function() MiniExtra.pickers.visit_paths() end, { desc = "Visits (cwd)" })
	vim.keymap.set("n", "<leader>gL", function() MiniExtra.pickers.git_commits() end, { desc = "Log (repo)" })
	vim.keymap.set("n", "<leader>gH", function() MiniExtra.pickers.git_hunks() end, { desc = "Hunks (repo)" })

	vim.keymap.set("n", "<leader>gh", function() MiniExtra.pickers.git_hunks({ path = "%" }) end, {
		desc = "Hunks (file)",
	})

	vim.keymap.set("n", "<leader>gm", function() MiniExtra.pickers.git_files({ scope = "modified" }) end, {
		desc = "Modified files",
	})

	vim.keymap.set("n", "<leader>V", function() MiniExtra.pickers.visit_paths({ cwd = "" }) end, {
		desc = "Visits (all)",
	})

	vim.keymap.set("n", "<leader>gl", function() MiniExtra.pickers.git_commits({ paths = "%" }) end, {
		desc = "Log (file)",
	})
end)

later(function()
	require("mini.git").setup({ command = { split = "horizontal" } })

	vim.keymap.set("n", "<leader>gA", "<cmd>Git add --all<cr>", { desc = "Add (repo)" })
	vim.keymap.set("n", "<leader>gP", "<cmd>Git push<cr>", { desc = "Push" })
	vim.keymap.set("n", "<leader>ga", "<cmd>Git add %<cr>", { desc = "Add (file)" })
	vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Commit" })
	vim.keymap.set("n", "<leader>gp", "<cmd>Git pull<cr>", { desc = "Pull" })
	vim.keymap.set({ "n", "x" }, "<leader>gs", function() MiniGit.show_at_cursor({ split = "horizontal" }) end, {
		desc = "Show at cursor",
	})
end)

later(
	function()
		require("mini.hipatterns").setup({
			highlighters = {
				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
				hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
			},
		})
	end
)

later(
	function()
		require("mini.jump2d").setup({
			mappings = { start_jumping = "<leader>j" },
			spotter = require("mini.jump2d").gen_spotter.pattern("[^%s%p]+"),
			view = { dim = true, n_steps_ahead = 2 },
		})
	end
)

later(function()
	require("mini.keymap").setup()

	MiniKeymap.map_multistep("i", "<c-n>", { "minisnippets_next", "pmenu_next" })
	MiniKeymap.map_multistep("i", "<c-p>", { "pmenu_prev", "minisnippets_prev" })
	MiniKeymap.map_multistep("i", "<cr>", { "pmenu_accept", "minipairs_cr" })
	MiniKeymap.map_multistep("i", "<bs>", { "minipairs_bs" })
	MiniKeymap.map_combo({ "i", "c", "x", "s" }, "jk", "<bs><bs><esc>")
	MiniKeymap.map_combo({ "i", "c", "x", "s" }, "kj", "<bs><bs><esc>")
	MiniKeymap.map_combo({ "i", "c", "x", "s", "n" }, "<esc><esc>", function() vim.cmd("nohlsearch") end)
end)

later(function()
	require("mini.misc").setup()

	MiniMisc.setup_auto_root()
	MiniMisc.setup_restore_cursor()
	MiniMisc.setup_termbg_sync()

	vim.keymap.set("n", "<leader>W", function() MiniMisc.setup_auto_root() end, { desc = "Change working dir" })
	vim.keymap.set("n", "<leader>z", function() MiniMisc.zoom() end, { desc = "Zoom" })
	vim.keymap.set("n", "<leader>=", function() MiniMisc.resize_window() end, {
		noremap = true,
		desc = "Resize to default size",
	})
end)

later(
	function()
		require("mini.move").setup({
			mappings = {
				down = "<s-j>",
				left = "<s-h>",
				right = "<s-l>",
				up = "<s-k>",
				line_down = "",
				line_left = "",
				line_right = "",
				line_up = "",
			},
		})
	end
)

later(function()
	require("mini.snippets").setup({
		snippets = {
			require("mini.snippets").gen_loader.from_lang(),
		},
		mappings = {
			expand = "<c-j>",
			stop = "<c-c>",
			jump_next = "",
			jump_prev = "",
		},
	})

	MiniSnippets.start_lsp_server()
end)

later(
	function()
		require("mini.surround").setup({
			mappings = {
				add = "sa",
				find = "sf",
				find_left = "sF",
				highlight = "sh",
				replace = "sr",
				update_n_lines = "sn",
				suffix_last = "l",
				suffix_next = "n",
			},
		})
	end
)

later(function()
	require("mini.pick").setup({
		mappings = {
			refine = "<c-r>",
			refine_marked = "<a-r>",
			paste = "<c-y>",
			choose_marked = "<c-q>",
		},
		window = {
			config = {
				border = vim.g.border,
			},
		},
	})

	vim.ui.select = MiniPick.ui_select

	vim.keymap.set("n", "<leader>/", function() MiniPick.builtin.grep_live() end, { desc = "Live grep" })
	vim.keymap.set("n", "<leader>?", function() MiniPick.builtin.help() end, { desc = "Help" })
	vim.keymap.set("n", "<leader><leader>", function() MiniPick.builtin.files() end, { desc = "Files" })
	vim.keymap.set("n", "<c-p>", function()
		MiniPick.builtin.buffers(nil, {
			mappings = {
				wipeout = {
					char = "<c-d>",
					func = function() vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {}) end,
				},
			},
		})
	end, { desc = "Buffers" })
end)

later(function()
	require("mini.files").setup({
		windows = { preview = true },
		mappings = {
			close = "q",
			go_in = "l",
			go_in_plus = "<cr>",
			go_out = "h",
			go_out_plus = "H",
			reset = "<bs>",
			reveal_cwd = "@",
			show_help = "?",
			synchronize = "=",
			trim_left = "<",
			trim_right = ">",
		},
	})

	vim.keymap.set("n", "<leader>e", function()
		if not MiniFiles.close() then
			local path = vim.fn.expand("%:p:h")
			if vim.uv.fs_stat(path) then
				MiniFiles.open(path, true)
				return
			end
			MiniFiles.open(nil, true)
		end
	end, { desc = "Explorer" })

	vim.api.nvim_create_autocmd("User", {
		desc = "Set mini.files keybindings",
		pattern = "MiniFilesBufferCreate",
		callback = function(event)
			local bufnr = event.data.buf_id

			local split = function(direction, close_on_file)
				return function()
					local new_win
					local win = MiniFiles.get_explorer_state().target_window

					if win ~= nil then
						vim.api.nvim_win_call(win, function()
							vim.cmd("belowright " .. direction .. " split")
							new_win = vim.api.nvim_get_current_win()
						end)

						MiniFiles.set_target_window(new_win)
						MiniFiles.go_in({ close_on_file = close_on_file })
					end
				end
			end

			vim.keymap.set("n", "-", split("horizontal", true), {
				noremap = true,
				buffer = bufnr,
				desc = "Open file (split)",
			})

			vim.keymap.set("n", "\\", split("vertical", true), {
				noremap = true,
				buffer = bufnr,
				desc = "Open file (vsplit)",
			})

			vim.keymap.set("n", ".", function()
				local filter_show = function() return true end

				local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end

				vim.g.mini_show_dotfiles = not vim.g.mini_show_dotfiles

				MiniFiles.refresh({ content = { filter = vim.g.mini_show_dotfiles and filter_show or filter_hide } })
			end, { noremap = true, buffer = bufnr, desc = "Toggle dotfiles" })

			vim.keymap.set("n", "go", function()
				local fs_entry = MiniFiles.get_fs_entry()

				if not fs_entry then
					vim.notify("No file selected", vim.log.levels.ERROR, { title = "mini.nvim" })
					return
				end

				vim.schedule(function()
					vim.notify("Opening " .. fs_entry.name, vim.log.levels.INFO, { title = "mini.nvim" })
					vim.ui.open(fs_entry.path)
				end)
			end, { noremap = true, buffer = bufnr, desc = "Open file" })

			vim.keymap.set("n", "gs", function()
				local grug_far = require("grug-far")

				local cur_entry_path = MiniFiles.get_fs_entry().path
				local prefills = { paths = vim.fs.dirname(cur_entry_path) }

				if not grug_far.has_instance("explorer") then
					grug_far.open({
						instanceName = "explorer",
						prefills = prefills,
						staticTitle = "Find and Replace from Explorer",
					})
				else
					grug_far.get_instance("explorer"):open()
					grug_far.get_instance("explorer"):update_input_values(prefills, false)
				end
			end, { noremap = true, buffer = bufnr, desc = "Search with grug-far.nvim" })
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		desc = "LSP-aware file renaming",
		pattern = "MiniFilesActionRename",
		callback = function(event) Snacks.rename.on_rename_file(event.data.from, event.data.to) end,
	})

	vim.api.nvim_create_autocmd("User", {
		desc = "Set border for mini.files window",
		pattern = "MiniFilesWindowOpen",
		callback = function(event) vim.api.nvim_win_set_config(event.data.win_id, { border = vim.g.border }) end,
	})
end)
