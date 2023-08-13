local lspconfig = require("lspconfig")
local lspconfig_utils = require("lspconfig.util")

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
    return
end

local lsp_signature_status, lsp_signature = pcall(require, "lsp_signature")
if not lsp_signature_status then
    return
end

local ltex_extra_status, ltex_extra = pcall(require, "ltex_extra")
if not ltex_extra_status then
    return
end

local lightbulb_status, lightbulb = pcall(require, "nvim-lightbulb")
if not lightbulb_status then
    return
end

-- set up lsp_signature
lsp_signature.setup()

-- set signs for diagnostics
local signs = { Error = " ", Warn = " ", Hint = "󱍄 ", Info = " " }

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

lspconfig.ltex.setup({
    capabilities = capabilities,
    on_attach = function()
        ltex_extra.setup({
            load_langs = { "en-US", "pt-BR" },
            path = vim.fn.expand("~") .. "/.local/share/ltex",
        })
    end,
    settings = {
        ltex = {
            filetypes = { "markdown", "quarto" },
            language = "auto",
            checkFrequency = "save",
            additionalRules = {
                enablePickyRules = true,
                motherTongue = "pt-BR",
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
