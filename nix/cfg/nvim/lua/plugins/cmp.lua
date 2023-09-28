-- [[ imports ]] --------------------------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local vscode_loaders = require("luasnip.loaders.from_vscode")
local pandoc = require("cmp_pandoc")

-- [[ luasnip ]] --------------------------------------------------------
luasnip.config.setup()

-- load vscode like snippets from plugins
vscode_loaders.lazy_load()

-- [[ pandoc ]] ---------------------------------------------------------
pandoc.setup({
	crossref = {
		enable_nabla = true,
	},
})

-- [[ completion setup ]] -----------------------------------------------
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
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
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	-- sources for autocompletion
	sources = cmp.config.sources({
		{ name = "buffer" }, -- text within current buffer
		{ name = "luasnip" }, -- snippets
		{ name = "nvim_lsp" }, -- lsp
		{ name = "path" }, -- file system paths
		{ name = "cmp_pandoc" }, -- bibtex references
	}),
	-- configure lspkind for vscode like icons
	formatting = {
		format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }),
	},
})
