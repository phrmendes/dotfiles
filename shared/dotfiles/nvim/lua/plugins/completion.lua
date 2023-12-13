local cmp = require("cmp")
local luasnip = require("luasnip")

vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

require("cmp_pandoc").setup({
	filetypes = { "pandoc", "markdown", "quarto" },
	crossref = { enable_nabla = true },
})

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
		{ name = "otter" },
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "luasnip" },
		{ name = "cmp_pandoc" },
		{ name = "cmp_zotcite" },
		{ name = "latex_symbols" },
		{ name = "emoji" },
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
