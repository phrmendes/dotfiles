local cmp = require("cmp")
local lspkind = require("lspkind")
local utils = require("utils")

-- [[ completion setup ]] -----------------------------------------------
cmp.setup({
	snippet = {
		expand = utils.luasnip.expand,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Left>"] = cmp.mapping(utils.luasnip.tab, { "i", "s" }),
		["<C-Right>"] = cmp.mapping(utils.luasnip.s_tab, { "i", "s" }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
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
	-- sources for autocompletion
	sources = cmp.config.sources({
		{ name = "buffer" }, -- text within current buffer
		{ name = "cmp_zotcite" }, -- zotcite
		{ name = "luasnip" }, -- snippets
		{ name = "nvim_lsp" }, -- lsp
		{ name = "path" }, -- file system paths
	}),
	-- configure lspkind for vscode like icons
	formatting = {
		format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }),
	},
})
