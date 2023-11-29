local lspconfig = require("lspconfig")
local wk = require("which-key")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(_, bufnr)
	wk.register({
		D = { vim.lsp.buf.declaration, "LSP: go to declaration" },
		d = { "<cmd>Telescope lsp_definitions<cr>", "LSP: go to definitions" },
		i = { "<cmd>Telescope lsp_implementations<cr>", "LSP: go to implementations" },
		r = { "<cmd>Telescope lsp_references<cr>", "LSP: go to references" },
		t = { "<cmd>Telescope lsp_type_definitions<cr>", "LSP: go to type definitions" },
	}, { prefix = "g", mode = "n", buffer = bufnr })

	wk.register({
		K = { vim.lsp.buf.signature_help, "LSP: show signature help" },
		S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "LSP: workspace symbols" },
		k = { vim.lsp.buf.hover, "LSP: show hover documentation" },
		r = { vim.lsp.buf.rename, "LSP: rename symbol" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "LSP: document symbols" },
	}, { prefix = "<leader>", mode = "n", buffer = bufnr })

	wk.register({
		name = "code",
		a = { vim.lsp.buf.code_action, "Actions" },
		l = { vim.lsp.codelens.run, "Lens" },
	}, { prefix = "<leader>c", mode = { "n", "x" }, buffer = bufnr })

	wk.register({
		name = "debug/diagnostics",
		d = { "<cmd>TroubleToggle document_diagnostics<cr>", "LSP: document diagnostics" },
		f = { vim.diagnostic.open_float, "LSP: floating diagnostics message" },
		w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "LSP: workspace diagnostics" },
	}, { prefix = "<leader>d", mode = "n", buffer = 0 })
end

local servers = {
	"ansiblels",
	"bashls",
	"docker_compose_language_service",
	"dockerls",
	"helm_ls",
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
		on_attach = on_attach,
	})
end

lspconfig.jsonls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "vscode-json-languageserver", "--stdio" },
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

lspconfig.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
			},
		},
	},
})

require("plugins.lsp.icons")
require("plugins.lsp.linters")
require("plugins.lsp.formatters")
require("plugins.lsp.ltex")
