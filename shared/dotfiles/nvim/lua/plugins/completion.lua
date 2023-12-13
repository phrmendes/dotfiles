local cmp = require("cmp")
local luasnip = require("luasnip")

require("cmp_pandoc").setup({ crossref = { enable_nabla = true } })

vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-q>"] = cmp.mapping.abort(),
		["<C-a>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<S-CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-CR>"] = function(fallback)
			cmp.abort()
			fallback()
		end,
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
	}, {
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
		experimental = {
			ghost_text = {
				hl_group = "CmpGhostText",
			},
		},
	},
	window = {
		documentation = {
			border = require("utils").border,
		},
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

local md_sources = {
	{ name = "otter" },
	{ name = "luasnip" },
	{ name = "path" },
	{ name = "cmp_pandoc" },
	{ name = "latex_symbols", option = { strategy = 2 } },
}

if vim.fn.has("mac") == 0 then
	md_sources = table.insert(md_sources, { name = "cmp_zotcite" })
end

cmp.setup.filetype({ "markdown", "quarto" }, {
	sources = cmp.config.sources(md_sources, {
		{ name = "buffer" },
	}),
})
