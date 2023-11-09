local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local fn = vim.fn

local cmp_nvim_lsp = require("cmp_nvim_lsp")
local formatters = require("conform")
local linters = require("lint")
local lsp_signature = require("lsp_signature")
local lspconfig = require("lspconfig")
local neodev = require("neodev")

-- [[ augroups ]] -------------------------------------------------------
local lsp_augroup = augroup("UserLspConfig", { clear = true })

-- [[ capabilities ]] ---------------------------------------------------
local capabilities = cmp_nvim_lsp.default_capabilities()

-- [[ general servers configuration ]] ----------------------------------
local servers = {
	"ansiblels",
	"bashls",
	"dartls",
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
	})
end

-- [[ specific servers configuration ]] ---------------------------------
lspconfig.jsonls.setup({
	capabilities = capabilities,
	cmd = { "vscode-json-languageserver", "--stdio" },
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
			completion = { callSnippet = "Replace" },
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
			workspace = {
				checkThirdParty = false,
				library = {
					[fn.expand("$VIMRUNTIME/lua")] = true,
					[fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

-- [[ neodev ]] ---------------------------------------------------------
neodev.setup()

-- [[ linters ]] --------------------------------------------------------
linters.linters_by_ft = {
	nix = { "statix" },
	sh = { "shellcheck" },
}

autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lsp_augroup,
	callback = function()
		linters.try_lint()
	end,
})

-- [[ formatters ]] -----------------------------------------------------
formatters.setup({
	format_after_save = {
		lsp_fallback = true,
	},
})

formatters.formatters.tex = {
	command = "latexindent.pl",
	args = { "-" },
	stdin = true,
}

formatters.formatters_by_ft = {
	dart = { "dart_format" },
	json = { "prettier" },
	lua = { "stylua" },
	markdown = { "prettier" },
	nix = { "alejandra" },
	python = { "ruff" },
	scala = { "scalafmt" },
	sh = { "shellharden" },
	terraform = { "terraform_fmt" },
	toml = { "taplo" },
	yaml = { "prettier" },
}

-- [[ LSP utils ]] ------------------------------------------------------
-- enable lsp_signature
lsp_signature.setup()

-- diagnostic icons
local diagnostics_signs = {
	Error = " ",
	Warn = " ",
	Hint = "󱍄 ",
	Info = " ",
}

for type, icon in pairs(diagnostics_signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
