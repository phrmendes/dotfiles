-- [[ imports ]] --------------------------------------------------------
local cmp = require("cmp")
local lspkind = require("lspkind")
local utils = require("core.utils")

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
		["<Tab>"] = cmp.mapping(utils.luasnip.tab, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(utils.luasnip.s_tab, { "i", "s" }),
	}),
	-- sources for autocompletion
	sources = cmp.config.sources({
		{ name = "buffer" }, -- text within current buffer
		{ name = "luasnip" }, -- snippets
		{ name = "nvim_lsp" }, -- lsp
		{ name = "path" }, -- file system paths
	}),
	-- configure lspkind for vscode like icons
	formatting = {
		format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }),
	},
})
