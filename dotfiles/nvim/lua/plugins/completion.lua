local cmp = require("cmp")
local luasnip = require("luasnip")
local border = cmp.config.window.bordered()
local utils = require("utils")

require("cmp_pandoc").setup({
	filetypes = { "quarto", "markdown" },
	crossref = {
		documentation = true,
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
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<TAB>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			elseif utils.has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-TAB>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-CR>"] = function(fallback)
			cmp.abort()
			fallback()
		end,
	}),
	formatting = {
		format = require("lspkind").cmp_format({
			ellipsis_char = "...",
			maxwidth = 50,
			mode = "symbol",
			symbol_map = {
				otter = "🦦",
				Copilot = "",
			},
		}),
	},
	window = {
		completion = border,
		documentation = border,
	},
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "copilot" },
		{ name = "otter" },
		{ name = "nvim_lsp" },
		{ name = "luasnip", keyword_length = 3, max_item_count = 3 },
		{ name = "cmp_pandoc" },
		{ name = "buffer", keyword_length = 5, max_item_count = 3 },
		{ name = "latex_symbols", option = { strategy = 2 } },
		{ name = "treesitter", keyword_length = 5, max_item_count = 3 },
	}),
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "cmdline", max_item_count = 10, keyword_length = 2 },
		{ name = "path" },
	}),
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

luasnip.filetype_extend("quarto", { "markdown" })
