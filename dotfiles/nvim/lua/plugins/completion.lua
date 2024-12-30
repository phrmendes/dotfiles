local border = require("utils").borders.border

require("cmp_pandoc").setup({
	filetypes = { "quarto", "markdown" },
})

require("blink.cmp").setup({
	signature = {
		enabled = true,
		window = { border = border },
	},
	completion = {
		list = {
			selection = "manual",
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
		["<c-e>"] = { "hide" },
		["<cr>"] = { "accept", "fallback" },
		["<c-l>"] = { "snippet_forward", "fallback" },
		["<c-h>"] = { "snippet_backward", "fallback" },
		["<c-p>"] = { "select_prev", "fallback" },
		["<c-n>"] = { "select_next", "fallback" },
		["<c-u>"] = { "scroll_documentation_up", "fallback" },
		["<c-d>"] = { "scroll_documentation_down", "fallback" },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer", "dadbod", "lazydev", "pandoc" },
		providers = {
			lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
			dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
			pandoc = { name = "cmp_pandoc", module = "blink.compat.source" },
		},
	},
	enabled = function()
		return not vim.tbl_contains({ "minifiles", "snacks_input" }, vim.bo.filetype)
	end,
})
