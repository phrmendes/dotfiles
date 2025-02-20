local border = require("utils").borders.border

return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"echasnovski/mini.nvim",
		"folke/lazydev.nvim",
	},
	version = "*",
	event = { "InsertEnter", "CmdLineEnter" },
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
			["<c-k>"] = { "show", "show_documentation", "hide_documentation" },
			["<c-c>"] = { "hide", "fallback" },
			["<cr>"] = { "accept", "fallback" },
			["<c-l>"] = { "snippet_forward", "fallback" },
			["<c-h>"] = { "snippet_backward", "fallback" },
			["<c-p>"] = { "select_prev", "fallback" },
			["<c-n>"] = { "select_next", "fallback" },
			["<c-u>"] = { "scroll_documentation_up", "fallback" },
			["<c-d>"] = { "scroll_documentation_down", "fallback" },
		},
		cmdline = {
			keymap = {
				["<s-tab>"] = { "select_prev", "fallback" },
				["<tab>"] = { "select_next", "fallback" },
				["<cr>"] = { "accept", "fallback" },
				["<c-c>"] = { "hide", "fallback" },
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "dadbod", "lazydev" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
					enabled = function() return vim.tbl_contains({ "lua" }, vim.bo.filetype) end,
				},
				dadbod = {
					name = "Dadbod",
					module = "vim_dadbod_completion.blink",
					enabled = function() return vim.tbl_contains({ "sql", "mysql", "plsql" }, vim.bo.filetype) end,
				},
			},
		},
		enabled = function() return not vim.tbl_contains({ "snacks_picker_input", "snacks_input" }, vim.bo.filetype) end,
	},
}
