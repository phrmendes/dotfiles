local cmp = require("cmp")
local luasnip = require("luasnip")
local utils = require("utils")
local border = cmp.config.window.bordered()

local default = {
	{ name = "path" },
	{ name = "emoji" },
	{ name = "buffer" },
}

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<S-CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-c>"] = function(fallback)
			cmp.abort()
			fallback()
		end,
		["<TAB>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif utils.has_words_before() then
				cmp.complete()
			elseif vim.b._copilot_suggestion ~= nil then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes(vim.fn["copilot#Accept"](), true, true, true), "")
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-TAB>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
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
