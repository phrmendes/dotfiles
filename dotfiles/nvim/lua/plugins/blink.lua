local build = function(params)
	local notify = {
		error = vim.schedule_wrap(
			function(err) vim.notify(("Building `blink.cmp` failed:\n%s"):format(err), vim.log.levels.ERROR) end
		),
		success = vim.schedule_wrap(
			function(path) vim.notify(("Built `blink.cmp` successfully in %s"):format(path), vim.log.levels.INFO) end
		),
	}

	vim.system({ "nix", "run", ".#build-plugin" }, { cwd = params.path }, function(out)
		if out.code ~= 0 then
			notify.error(out.stderr or out.stdout or "Unknown error")
			return
		end

		notify.success(params.path)
	end)
end

MiniDeps.now(function()
	MiniDeps.add({
		source = "Saghen/blink.cmp",
		depends = {
			"echasnovski/mini.nvim",
			"folke/lazydev.nvim",
			"kristijanhusak/vim-dadbod-completion",
		},
		hooks = {
			post_install = build,
			post_checkout = build,
		},
	})

	require("blink.cmp").setup({
		signature = {
			enabled = true,
			window = { border = vim.g.border },
		},
		completion = {
			list = {
				selection = {
					auto_insert = true,
					preselect = false,
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = { border = vim.g.border },
			},
			menu = {
				border = vim.g.border,
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								local icon, _, _ = require("mini.icons").get("lsp", ctx.kind)

								return icon
							end,
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
						kind = {
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
					},
				},
			},
		},
		snippets = { preset = "mini_snippets" },
		keymap = {
			["<c-e>"] = { "hide", "fallback" },
			["<c-k>"] = { "show", "show_documentation", "hide_documentation" },
			["<c-d>"] = { "scroll_documentation_down", "fallback" },
			["<c-u>"] = { "scroll_documentation_up", "fallback" },
			["<cr>"] = { "accept", "fallback" },
		},
		cmdline = {
			enabled = true,
			keymap = {
				["<tab>"] = { "show_and_insert", "select_next" },
				["<s-tab>"] = { "show_and_insert", "select_prev" },
				["<cr>"] = { "accept", "fallback" },
				["<c-c>"] = { "hide", "fallback" },
			},
		},
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "omni", "buffer" },
			per_filetype = { sql = { "dadbod" } },
			providers = {
				dadbod = {
					name = "Dadbod",
					module = "vim_dadbod_completion.blink",
				},
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
		enabled = function()
			return not vim.list_contains({
				"copilot-chat",
				"dap-repl",
				"dap-view",
				"dap-view-term",
				"grug-far",
				"minifiles",
				"snacks_input",
				"snacks_picker_input",
			}, vim.bo.filetype)
		end,
	})

	local augroup = vim.api.nvim_create_augroup("UserBlinkCmp", {})

	vim.api.nvim_create_autocmd("User", {
		desc = "Hide Copilot suggestions when BlinkCmp menu is open",
		group = augroup,
		pattern = "BlinkCmpMenuOpen",
		callback = function() vim.b.copilot_suggestion_hidden = true end,
	})

	vim.api.nvim_create_autocmd("User", {
		desc = "Show Copilot suggestions when BlinkCmp menu is closed",
		group = augroup,
		pattern = "BlinkCmpMenuClose",
		callback = function() vim.b.copilot_suggestion_hidden = false end,
	})
end)
