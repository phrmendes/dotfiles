local cmp = require("cmp")
local luasnip = require("luasnip")
local border = cmp.config.window.bordered()

require("cmp_pandoc").setup({
	filetypes = { "quarto" },
	crossref = {
		enable_nabla = true,
	},
})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-q>"] = function(fallback)
			cmp.abort()
			fallback()
		end,
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "path" },
		{ name = "buffer" },
	}),
	formatting = {
		format = require("lspkind").cmp_format({
			ellipsis_char = "...",
			maxwidth = 50,
			mode = "symbol",
			symbol_map = {
				otter = "🦦",
			},
		}),
	},
	window = {
		completion = border,
		documentation = border,
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "cmdline" },
		{ name = "path" },
	}),
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.filetype("quarto", {
	sources = cmp.config.sources({
		{ name = "luasnip" },
		{ name = "otter" },
		{ name = "nvim_lsp" },
		{ name = "cmp_pandoc" },
		{ name = "latex_symbols" },
	}, {
		{ name = "path" },
		{ name = "buffer" },
	}),
})

cmp.setup.filetype("markdown", {
	sources = cmp.config.sources({
		{ name = "luasnip" },
		{ name = "cmp_zotcite" },
		{ name = "cmp_pandoc" },
		{ name = "latex_symbols" },
	}, {
		{ name = "path" },
		{ name = "buffer" },
	}),
})
