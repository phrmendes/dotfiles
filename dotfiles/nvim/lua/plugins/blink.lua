MiniDeps.now(function()
	MiniDeps.add({
		source = "Saghen/blink.cmp",
		depends = {
			"echasnovski/mini.nvim",
			"folke/lazydev.nvim",
			"kristijanhusak/vim-dadbod-completion",
		},
	})

	package.cpath = package.cpath .. ";" .. require("nix.blink")

	require("blink.cmp").setup({
		fuzzy = {
			prebuild_binaries = {
				download = false,
			},
		},
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
								local icon, _, _ = MiniIcons.get("lsp", ctx.kind)

								return icon
							end,
							highlight = function(ctx)
								local _, hl, _ = MiniIcons.get("lsp", ctx.kind)
								return hl
							end,
						},
						kind = {
							highlight = function(ctx)
								local _, hl, _ = MiniIcons.get("lsp", ctx.kind)
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
