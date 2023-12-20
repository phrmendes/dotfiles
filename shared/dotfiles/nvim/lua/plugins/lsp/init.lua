require("barbecue").setup({ exclude_filetypes = { "neo-tree", "starter" } })
require("lsp-format").setup()
require("lsp_signature").setup()
require("neodev").setup({ library = { plugins = { "nvim-dap-ui" }, types = true } })
require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
require("diagflow").setup()
require("plugins.lsp.handlers").setup()
require("plugins.lsp.ltex").setup()

local lsp_format = require("lsp-format")
local capabilities = require("plugins.lsp.utils").capabilities
local lspconfig = require("lspconfig")
local on_attach = require("plugins.lsp.utils").on_attach

lsp_format.setup()

local servers = {
	"ansiblels",
	"bashls",
	"docker_compose_language_service",
	"dockerls",
	"helm_ls",
	"marksman",
	"nil_ls",
	"ruff_lsp",
	"taplo",
	"terraformls",
	"texlab",
}

local linters = {
	shellcheck = require("efmls-configs.linters.shellcheck"),
	sqlfluff = require("efmls-configs.linters.sqlfluff"),
	statix = require("efmls-configs.linters.statix"),
}

local formatters = {
	alejandra = require("efmls-configs.formatters.alejandra"),
	prettier = require("efmls-configs.formatters.prettier"),
	ruff = require("efmls-configs.formatters.ruff"),
	shellharden = require("efmls-configs.formatters.shellharden"),
	sql_formatter = require("efmls-configs.formatters.sql-formatter"),
	stylua = require("efmls-configs.formatters.stylua"),
	taplo = require("efmls-configs.formatters.taplo"),
	terraform_fmt = require("efmls-configs.formatters.terraform_fmt"),
}

local efm_languages = {
	json = { formatters.prettier },
	lua = { formatters.stylua },
	markdown = { formatters.prettier },
	nix = { linters.statix, formatters.alejandra },
	python = { formatters.ruff },
	sh = { linters.shellcheck, formatters.shellharden },
	sql = { linters.sqlfluff, formatters.sql_formatter },
	terraform = { formatters.terraform_fmt },
	toml = { formatters.taplo },
	yaml = { formatters.prettier },
}

for _, server in ipairs(servers) do
	lspconfig[server].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			completion = { callSnippet = "Replace" },
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
			workspace = {
				checkThirdParty = false,
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

lspconfig.pyright.setup({
	capabilities = capabilities,
	on_attach = on_attach,
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

lspconfig.jsonls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "vscode-json-languageserver", "--stdio" },
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

lspconfig.yamlls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		yaml = {
			keyOrdering = false,
			schemas = require("schemastore").yaml.schemas(),
			schemaStore = {
				enable = false,
				url = "",
			},
		},
	},
})

lspconfig.efm.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		lsp_format.on_attach(client, bufnr)
		on_attach(client, bufnr)
	end,
	filetypes = vim.tbl_keys(efm_languages),
	init_options = {
		documentFormatting = true,
		codeAction = true,
		documentRangeFormatting = true,
	},
	settings = {
		rootMarkers = { ".git/" },
		languages = efm_languages,
	},
})
