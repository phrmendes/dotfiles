require("plugins.lsp.handlers")
require("plugins.lsp.formatters")
require("plugins.lsp.linters")
require("plugins.lsp.ltex")

require("barbecue").setup({ exclude_filetypes = { "neo-tree", "starter" } })
require("diagflow").setup()
require("lsp_signature").setup()
require("neodev").setup({ library = { plugins = { "nvim-dap-ui" }, types = true } })
require("nvim-lightbulb").setup({ autocmd = { enabled = true } })

local capabilities = require("plugins.lsp.utils").capabilities
local lspconfig = require("lspconfig")
local on_attach = require("plugins.lsp.utils").on_attach
local html_capabilities = vim.lsp.protocol.make_client_capabilities()

html_capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = {
	"ansiblels",
	"bashls",
	"docker_compose_language_service",
	"dockerls",
	"helm_ls",
	"marksman",
	"nil_ls",
	"ruff_lsp",
	"tailwindcss",
	"taplo",
	"terraformls",
	"texlab",
}

for _, server in ipairs(servers) do
	lspconfig[server].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

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

lspconfig.html.setup({
	capabilities = html_capabilities,
})
