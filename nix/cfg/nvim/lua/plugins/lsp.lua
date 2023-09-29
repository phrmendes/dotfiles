-- [[ variables ]] ------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local lang = os.getenv("PROJECT_LANG") or "en"

-- [[ imports ]] --------------------------------------------------------
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local fidget = require("fidget")
local formatters = require("conform")
local linters = require("lint")
local lsp_signature = require("lsp_signature")
local lspconfig = require("lspconfig")
local ltex = require("ltex_extra")
local utils = require("utils")

-- [[ augroups ]] -------------------------------------------------------
local lsp_augroup = augroup("LspSettings", { clear = true })

-- [[ capabilities ]] ---------------------------------------------------
local capabilities = cmp_nvim_lsp.default_capabilities()

-- [[ general servers configuration ]] ----------------------------------
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
		on_attach = utils.on_attach,
	})
end

-- [[ specific servers configuration ]] ---------------------------------
lspconfig.jsonls.setup({
	capabilities = capabilities,
	on_attach = utils.on_attach,
	cmd = { "vscode-json-languageserver", "--stdio" },
})

lspconfig.pyright.setup({
	on_attach = utils.on_attach,
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
	on_attach = utils.on_attach,
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

ltex.setup({
	load_langs = { "en-US", "pt-BR" },
	path = vim.fn.expand("~/.local/share/ltex"),
	server_opts = {
		on_attach = utils.on_attach,
		capabilities = capabilities,
		settings = {
			ltex = {
				filetypes = { "markdown" },
				language = lang,
				additionalRules = {
					motherTongue = "pt-BR",
				},
			},
		},
	},
})

-- [[ linters ]] --------------------------------------------------------
linters.linters_by_ft = {
	sh = { "shellcheck" },
	nix = { "statix" },
	yaml = { "ansible_lint" },
}

autocmd({ "BufWritePost" }, {
	group = lsp_augroup,
	callback = function()
		linters.try_lint()
	end,
})

-- [[ formatters ]] -----------------------------------------------------
formatters.formatters.tex = {
	command = "latexindent.pl",
	args = { "-" },
	stdin = true,
}

formatters.formatters_by_ft = {
	json = { "prettier" },
	lua = { "stylua" },
	markdown = { "prettier" },
	nix = { "alejandra" },
	python = { "ruff" },
	scala = { "scalafmt" },
	sh = { "shfmt" },
	terraform = { "terraform_fmt" },
	toml = { "taplo" },
	yaml = { "prettier" },
}

-- [[ LSP utils ]] ------------------------------------------------------
-- nvim-lsp progress
fidget.setup()

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
