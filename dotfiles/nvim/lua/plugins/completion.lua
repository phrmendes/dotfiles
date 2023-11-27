local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")
local cmp_copilot = require("copilot_cmp")

cmp_copilot.setup()

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
		["<C-c>"] = cmp.mapping.abort(),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
	}),
	sources = cmp.config.sources({
		{ name = "copilot" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
	}, {
		{ name = "buffer" },
	}),
	formatting = {
		format = lspkind.cmp_format({
			ellipsis_char = "...",
			maxwidth = 50,
			mode = "symbol",
			symbol_map = {
				otter = "🦦",
				Copilot = "",
			},
		}),
	},
})

if vim.fn.has("mac") == 0 then
	local cmp_pandoc = require("cmp_pandoc")

	cmp_pandoc.setup({ crossref = { enable_nabla = true } })

	cmp.setup.filetype("quarto", {
		sources = cmp.config.sources({
			{ name = "otter" },
			{ name = "cmp_pandoc" },
			{ name = "luasnip" },
			{ name = "path" },
			{ name = "latex_symbols", option = { strategy = 2 } },
		}, {
			{ name = "buffer" },
		}),
	})

	cmp.setup.filetype("markdown", {
		sources = cmp.config.sources({
			{ name = "cmp_zotcite" },
			{ name = "luasnip" },
			{ name = "path" },
			{ name = "latex_symbols", option = { strategy = 2 } },
		}, {
			{ name = "buffer" },
		}),
	})
else
	cmp.setup.filetype("markdown", {
		sources = cmp.config.sources({
			{ name = "luasnip" },
			{ name = "path" },
			{ name = "buffer" },
		}),
	})
end
