local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
    return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
    return
end

-- set signs for diagnostics
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- config language servers
local autocmd = vim.api.nvim_create_autocmd
local capabilities = cmp_nvim_lsp.default_capabilities()
local clear = vim.api.nvim_clear_autocmds
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

lspconfig.ansiblels.setup({ capabilities = capabilities })
lspconfig.bashls.setup({ capabilities = capabilities })
lspconfig.dockerls.setup({ capabilities = capabilities })
lspconfig.marksman.setup({ capabilities = capabilities })
lspconfig.metals.setup({ capabilities = capabilities })
lspconfig.nil_ls.setup({ capabilities = capabilities })
lspconfig.ruff_lsp.setup({ capabilities = capabilities })
lspconfig.taplo.setup({ capabilities = capabilities })
lspconfig.terraformls.setup({ capabilities = capabilities })
lspconfig.texlab.setup({ capabilities = capabilities })
lspconfig.yamlls.setup({ capabilities = capabilities })

lspconfig.jsonls.setup({
    cmd = { "vscode-json-languageserver", "--stdio" },
    capabilities = capabilities,
})

lspconfig.efm.setup({
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            clear({ group = augroup, buffer = bufnr })
            autocmd("BufWritePost", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false, timeout_ms = 500 })
                end,
            })
        end
    end,
    capabilities = capabilities,
    cmd = { "efm-langserver" },
    args = { "-c", "~/.config/efm-langserver/config.yaml" },
    filetypes = {
        "json",
        "lua",
        "markdown",
        "nix",
        "python",
        "sh",
        "yaml",
        "toml",
        "scala",
    },
})

lspconfig.ltex.setup({
    capabilities = capabilities,
    settings = {
        ltex = { language = "en", additionalRules = { motherTongue = "pt-BR" } },
        filetypes = { "tex", "markdown", "quarto" },
    },
})

lspconfig.pyright.setup({
    capabilities = capabilities,
    settings = {
        single_file_support = true,
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "strict",
                useLibraryCodeForTypes = false,
                inlayHints = { variableTypes = true, functionReturnTypes = true },
            },
        },
    },
})

lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
})
