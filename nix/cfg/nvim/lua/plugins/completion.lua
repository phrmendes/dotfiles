local cmp = require("cmp")
local lspkind = require("lspkind")
local utils = require("utils")

cmp.setup({
	snippet = {
		expand = utils.luasnip.expand,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-J>"] = cmp.mapping(utils.luasnip.next_cmp, { "i", "s" }),
		["<C-K>"] = cmp.mapping(utils.luasnip.prev_cmp, { "i", "s" }),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-c>"] = cmp.mapping.abort(),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "path" },
	}, {
		{ name = "buffer" },
	}),
	formatting = {
		format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }),
	},
})
