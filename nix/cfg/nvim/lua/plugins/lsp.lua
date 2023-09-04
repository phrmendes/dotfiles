local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lsp_signature = require("lsp_signature")
local lspconfig = require("lspconfig")
local lspconfig_utils = require("lspconfig.util")
local ltex_extra = require("ltex_extra")

local efmls = {
    json = {
        linter = { jq = require("efmls-configs.linters.jq") },
formatter = { jq = require("efmls-configs.formatters.jq") },
    },
    lua = {
        formatter = { stylua = require("efmls-configs.formatters.stylua") },
    },
    nix = {
        linter = { statix = require("efmls-configs.linters.statix") },
        formatter = { alejandra = require("efmls-configs.formatters.alejandra") },
    },
    python = {
        formatter = { ruff = require("efmls-configs.formatters.ruff") },
    },
    scala = {
        formatter = { scalafmt = { formatCommand = "scalafmt --stdin", formatStdin = true } },
    },
    sh = {
        linter = { shellcheck = require("efmls-configs.linters.shellcheck") },
        formatter = { shfmt = require("efmls-configs.formatters.shfmt") },
    },
    terraform = {
        formatter = { terraform_fmt = require("efmls-configs.formatters.terraform_fmt") },
    },
    toml = {
        formatter = { taplo = { formatCommand = "taplo format -", formatStdin = true } },
    },
    yaml = {
        linter = { ansible_lint = require("efmls-configs.linters.ansible_lint") },
        formatter = { yq = { formatCommand = "yq . ${INPUT}" } },
    },
}

local efmls_languages = {
    json = { efmls.json.linter.jq, efmls.json.formatter.jq },
    lua = { efmls.lua.formatter.stylua },
    nix = { efmls.nix.linter.statix, efmls.nix.formatter.alejandra },
    python = { efmls.python.formatter.ruff },
    scala = { efmls.scala.formatter.scalafmt },
    sh = { efmls.sh.linter.shellcheck, efmls.sh.formatter.shfmt },
    terraform = { efmls.terraform.formatter.terraform_fmt },
    toml = { efmls.toml.formatter.taplo },
    yaml = { efmls.yaml.linter.ansible_lint, efmls.yaml.formatter.yq },
}

local diagnostics_signs = {
    Error = " ",
    Warn = " ",
    Hint = "󱍄 ",
    Info = " ",
}

-- set up lsp_signature
lsp_signature.setup()

for type, icon in pairs(diagnostics_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- config language servers
local capabilities = cmp_nvim_lsp.default_capabilities()
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

ltex_extra.setup({
    load_langs = { "en", "pt", "pt-BR" },
    init_check = true,
    path = ".ltex",
    server_opts = {
        capabilities = capabilities,
        settings = {
            ltex = {
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

-- linters and formatters
local efmls_config = {
    filetypes = vim.tbl_keys(efmls_languages),
    settings = {
        rootMarkers = { ".git/" },
        languages = efmls_languages,
    },
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
    },
}

lspconfig.efm.setup(vim.tbl_extend("force", efmls_config, {
    capabilities = capabilities,
}))
