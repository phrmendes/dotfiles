local cmp = require("cmp")
local luasnip = require("luasnip")
local borders = require("utils").borders

require("cmp_pandoc").setup({ filetypes = { "quarto" }, crossref = { enable_nabla = true } })
require("copilot_cmp").setup()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<cr>"] = cmp.mapping({
			s = cmp.mapping.confirm({ select = true }),
			i = function(fallback)
				if cmp.visible() and cmp.get_active_entry() then
					cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
				else
					fallback()
				end
			end,
		}),
		["<c-u>"] = cmp.mapping.scroll_docs(-4),
		["<c-d>"] = cmp.mapping.scroll_docs(4),
		["<c-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<c-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<bs>"] = cmp.mapping(function(fallback)
			cmp.abort()
			fallback()
		end, { "i", "s" }),
		["<c-l>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<c-h>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	formatting = {
		format = function(entry, item)
			local icon, hl = require("mini.icons").get("lsp", item.kind)
			local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })

			if color_item.abbr_hl_group then
				item.kind = color_item.abbr
				item.kind_hl_group = color_item.abbr_hl_group
			else
				item.kind = icon .. " " .. item.kind
				item.kind_hl_group = hl
			end

			return item
		end,
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "lazydev", group_index = 0 },
		{ name = "luasnip" },
		{ name = "async_path" },
	}, {
		{ name = "copilot" },
		{ name = "buffer", keyword_length = 5, max_item_count = 3 },
	}),
	window = {
		completion = borders,
		documentation = borders,
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	matching = { disallow_symbol_nonprefix_matching = false },
	sources = cmp.config.sources({
		{ name = "cmdline" },
		{ name = "async_path" },
	}),
})

cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
	sources = cmp.config.sources({
		{ name = "vim-dadbod-completion" },
	}, {
		{ name = "buffer", keyword_length = 5, max_item_count = 3 },
	}),
})

cmp.setup.filetype({ "quarto", "markdown" }, {
	sources = cmp.config.sources({
		{ name = "luasnip" },
		{ name = "cmp_pandoc" },
		{ name = "async_path" },
		{ name = "latex_symbols", option = { strategy = 2 } },
	}, {
		{ name = "buffer", keyword_length = 5, max_item_count = 3 },
	}),
})
