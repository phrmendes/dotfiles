local fn = vim.fn

local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then return end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then return end

local signs = {Error = " ", Warn = " ", Hint = "ﴞ ", Info = " "}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
end

-- config language servers
local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig.ansiblels.setup({capabilities = capabilities})
lspconfig.bashls.setup({capabilities = capabilities})
lspconfig.dockerls.setup({capabilities = capabilities})
lspconfig.marksman.setup({capabilities = capabilities})
lspconfig.metals.setup({capabilities = capabilities})
lspconfig.nil_ls.setup({capabilities = capabilities})
lspconfig.ruff_lsp.setup({capabilities = capabilities})
lspconfig.taplo.setup({capabilities = capabilities})
lspconfig.terraformls.setup({capabilities = capabilities})
lspconfig.texlab.setup({capabilities = capabilities})
lspconfig.yamlls.setup({capabilities = capabilities})
lspconfig.jsonls.setup({capabilities = capabilities})

lspconfig.efm.setup({
    capabilities = capabilities,
    init_options = {documentFormatting = true},
    filetypes = {
        "json", "lua", "markdown", "nix", "python", "sh", "yaml", "toml",
        "scala"
    }
})

lspconfig.ltex.setup({
    capabilities = capabilities,
    settings = {
        ltex = {language = "en", additionalRules = {motherTongue = "pt-BR"}},
        filetypes = {"tex", "markdown", "quarto"}
    }
})

lspconfig.pyright.setup({
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "strict",
                useLibraryCodeForTypes = true,
                inlayHints = {variableTypes = true, functionReturnTypes = true}
            }
        }
    }
})

lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {globals = {"vim"}},
            workspace = {
                library = {
                    [fn.expand("$VIMRUNTIME/lua")] = true,
                    [fn.stdpath("config") .. "/lua"] = true
                }
            }
        }
    }
})
