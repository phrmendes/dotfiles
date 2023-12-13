require("plugins.lsp.formatters")
require("plugins.lsp.linters")
require("plugins.lsp.ltex")
require("neodev").setup({ library = { plugins = { "nvim-dap-ui" }, types = true } })
require("lsp_signature").setup()
require("nvim-lightbulb").setup({ autocmd = { enabled = true } })

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local capabilities = require("plugins.lsp.utils").capabilities
local helm_group = augroup("HelmLspConfig", { clear = true })
local lspconfig = require("lspconfig")
local on_attach = require("plugins.lsp.utils").on_attach

local diagnostics_signs = {
	Error = "",
	Warn = "",
	Hint = "",
	Info = "",
}

for type, icon in pairs(diagnostics_signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = require("core.utils").border,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = require("core.utils").border,
})

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

lspconfig.yamlls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		yaml = {
			keyOrdering = false,
		},
	},
})

autocmd("FileType", {
	pattern = { "helm" },
	group = helm_group,
	callback = function()
		local server = vim.lsp.get_active_clients({ name = "yamlls", bufnr = 0 })

		for _, client in ipairs(server) do
			vim.lsp.stop_client(client.id)
		end
	end,
})
