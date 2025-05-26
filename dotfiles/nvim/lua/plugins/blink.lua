local border = require("utils").border

return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"echasnovski/mini.nvim",
		"folke/lazydev.nvim",
		"rafamadriz/friendly-snippets",
		"fang2hou/blink-copilot",
	},
	opts = {
		signature = {
			enabled = true,
			window = { border = border },
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
				window = { border = border },
			},
			menu = {
				border = border,
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
			["<c-c>"] = { "hide", "fallback" },
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
			default = { "lazydev", "copilot", "lsp", "path", "snippets", "omni", "buffer" },
			per_filetype = { sql = { "dadbod" } },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
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
			return not vim.tbl_contains({
				"copilot-chat",
				"dap-repl",
				"dap-view",
				"dap-view-term",
				"grug-far",
				"snacks_input",
				"snacks_picker_input",
			}, vim.bo.filetype)
		end,
	},
}
