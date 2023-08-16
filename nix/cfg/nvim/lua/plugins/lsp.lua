local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lsp_signature = require("lsp_signature")
local lspconfig = require("lspconfig")
local lspconfig_utils = require("lspconfig.util")
local ltex_extra = require("ltex_extra")
local configs = require("lspconfig.configs")

-- set up lsp_signature
lsp_signature.setup()

-- set signs for diagnostics
local signs = {
    Error = " ",
    Warn = " ",
    Hint = "󱍄 ",
    Info = " ",
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- config language servers
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local autocmd = vim.api.nvim_create_autocmd
local capabilities = cmp_nvim_lsp.default_capabilities()
local clear = vim.api.nvim_clear_autocmds
local servers = {
    "ansiblels",
    "bashls",
    "dockerls",
    "metals",
    "nil_ls",
    "ruff_lsp",
    "taplo",
    "terraformls",
    "texlab",
    "yamlls",
}

for _, server in ipairs(servers) do
    lspconfig[server].setup({
        capabilities = capabilities,
    })
end

-- special config for some language servers
lspconfig.marksman.setup({
    filetypes = { "markdown", "quarto" },
    capabilities = capabilities,
    root_dir = lspconfig_utils.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
})

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

ltex_extra.setup({
    load_langs = { "en", "pt", "pt-BR" },
    init_check = true,
    path = ".ltex",
    server_opts = {
        capabilities = capabilities,
        settings = {
            ltex = {
                filetypes = { "markdown", "quarto" },
                language = "auto",
                additionalRules = {
                    enablePickyRules = true,
                    motherTongue = "pt-BR",
                },
            },
        },
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
                inlayHints = {
                    variableTypes = true,
                    functionReturnTypes = true,
                },
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

if not configs.helm_ls then
    configs.helm_ls = {
        default_config = {
            cmd = { "helm_ls", "serve" },
            filetypes = { "helm" },
            root_dir = function(fname)
                return lspconfig_utils.root_pattern("Chart.yaml")(fname)
            end,
        },
    }
end

lspconfig.helm_ls.setup({
    filetypes = { "helm" },
    cmd = { "helm_ls", "serve" },
})
