local cmp = require("cmp")
local luasnip = require("luasnip")
local border = cmp.config.window.bordered()

local default = {
	{ name = "path" },
	{ name = "buffer" },
}

require("cmp_pandoc").setup({
	filetypes = { "quarto" },
	crossref = { enable_nabla = true },
})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-l>"] = cmp.mapping(function()
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			end
		end, { "i", "s" }),
		["<C-h>"] = cmp.mapping(function()
			if luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { "i", "s" }),
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
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, default),
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

cmp.setup.filetype("markdown", {
	sources = cmp.config.sources({
		{ name = "cmp_zotcite" },
		{ name = "otter" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "latex_symbols", option = { strategy = 2 } },
	}, default),
})

cmp.setup.filetype("quarto", {
	sources = cmp.config.sources({
		{ name = "cmp_pandoc" },
		{ name = "otter" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "latex_symbols", option = { strategy = 2 } },
	}, default),
})
