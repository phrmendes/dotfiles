local lspconfig = require("lspconfig")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(_, bufnr)
	local map = function(key, value, desc, type)
		if type == nil then
			type = "n"
		end

		vim.keymap.set(type, key, value, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	map("<leader>D", "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace diagnostics")
	map("<leader>F", vim.diagnostic.open_float, "floating diagnostics")
	map("<leader>S", "<cmd>Telescope lsp_workspace_symbols<cr>", "workspace symbols")
	map("<leader>a", vim.lsp.buf.code_action, "code actions", { "n", "x" })
	map("<leader>d", "<cmd>TroubleToggle document_diagnostics<cr>", "document diagnostics")
	map("<leader>h", vim.lsp.buf.signature_help, "show signature help")
	map("<leader>k", vim.lsp.buf.hover, "show hover documentation")
	map("<leader>r", vim.lsp.buf.rename, "rename symbol")
	map("<leader>s", "<cmd>Telescope lsp_document_symbols<cr>", "document symbols")
	map("gD", vim.lsp.buf.declaration, "go to declaration")
	map("gd", "<cmd>Telescope lsp_definitions<CR>", "go to definition")
	map("gi", "<cmd>Telescope lsp_implementations<cr>", "go to implementations")
	map("gr", "<cmd>Telescope lsp_references<cr>", "go to references")
	map("gt", "<cmd>Telescope lsp_type_definitions<cr>", "go to type definition")
end

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
