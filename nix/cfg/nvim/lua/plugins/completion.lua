local cmp = require("cmp")
local lspkind = require("lspkind")
local utils = require("core.utils")
local cmp_pandoc = require("cmp_pandoc")

-- [[ completion setup ]] -----------------------------------------------
cmp.setup({
	snippet = {
		expand = utils.luasnip.expand,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(4), -- scroll documentation down
		["<C-n>"] = cmp.mapping.select_next_item(), -- next suggestion
		["<C-p>"] = cmp.mapping.select_prev_item(), -- previous suggestion
		["<C-u>"] = cmp.mapping.scroll_docs(-4), -- scroll documentation up
		["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
		["<C-q>"] = cmp.mapping.abort(), -- close completion window
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		}),
		["<C-Left>"] = cmp.mapping(utils.luasnip.tab, { "i", "s" }),
		["<C-Right>"] = cmp.mapping(utils.luasnip.s_tab, { "i", "s" }),
	}),
	-- sources for autocompletion
	sources = cmp.config.sources({
		{ name = "buffer" }, -- text within current buffer
		{ name = "cmp_pandoc" }, -- pandoc citations
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

cmp_pandoc.setup({
	crossref = {
		enable_nabla = true,
	},
})
