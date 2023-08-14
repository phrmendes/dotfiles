local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local vscode_loaders = require("luasnip.loaders.from_vscode")

-- load vscode like snippets from plugins
vscode_loaders.lazy_load()

-- completion setup
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-n>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-J>"] = cmp.mapping.scroll_docs(-4), -- scroll documentation up
        ["<C-K>"] = cmp.mapping.scroll_docs(4), -- scroll documentation down
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-q>"] = cmp.mapping.abort(),      -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
    }),
    -- sources for autocompletion
    sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- lsp
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
    }),
    -- configure lspkind for vscode like icons
    formatting = {
        format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }),
    },
})
