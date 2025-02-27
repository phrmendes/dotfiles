local border = require("utils").borders.border

return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"echasnovski/mini.nvim",
		"folke/lazydev.nvim",
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
							ellipsis = false,
							text = function(ctx)
								local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
								return kind_icon
							end,
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
					},
				},
			},
		},
		keymap = {
			["<cr>"] = { "accept", "fallback" },
			["<c-c>"] = { "hide", "fallback" },
			["<c-k>"] = { "show", "show_documentation", "hide_documentation" },
			["<c-d>"] = { "scroll_documentation_down", "fallback" },
			["<c-u>"] = { "scroll_documentation_up", "fallback" },
			["<c-h>"] = { "snippet_backward", "fallback" },
			["<c-l>"] = { "snippet_forward", "fallback" },
			["<c-n>"] = { "select_next", "fallback" },
			["<c-p>"] = { "select_prev", "fallback" },
		},
		cmdline = {
			enabled = true,
			keymap = {
				["<tab>"] = { "show_and_insert", "select_next" },
				["<s-tab>"] = { "show_and_insert", "select_prev" },
				["<c-n>"] = { "select_next" },
				["<c-p>"] = { "select_prev" },
				["<cr>"] = { "accept", "fallback" },
				["<c-c>"] = { "hide", "fallback" },
			},
		},
		sources = {
			default = { "lazydev", "lsp", "path", "snippets", "omni", "buffer" },
			per_filetype = { sql = { "dadbod" } },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				dadbod = {
					name = "Dadbod",
					module = "vim_dadbod_completion.blink",
				},
			},
		},
		enabled = function()
			return not vim.tbl_contains({ "snacks_picker_input", "snacks_input", "copilot-chat" }, vim.bo.filetype)
		end,
	},
}
