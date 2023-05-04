local fn = vim.fn

local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- config language servers
local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig.rnix.setup({
	capabilities = capabilities,
})

lspconfig.terraformls.setup({
	capabilities = capabilities,
})

lspconfig.bashls.setup({
	capabilities = capabilities,
})

lspconfig.dockerls.setup({
	capabilities = capabilities,
})

lspconfig.gopls.setup({
	capabilities = capabilities,
})

lspconfig.ltex.setup({
	capabilities = capabilities,
	settings = {
		ltex = {
			language = "en",
			additionalRules = {
				motherTongue = "pt-BR",
			},
		},
		filetypes = { "tex", "markdown" },
	},
})

lspconfig.pyright.setup({
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				useLibraryCodeForTypes = true,
				typeCheckingMode = "basic",
				diagnosticMode = "workspace",
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
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[fn.expand("$VIMRUNTIME/lua")] = true,
					[fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
