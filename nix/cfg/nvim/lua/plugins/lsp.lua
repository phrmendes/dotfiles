-- [[ variables ]] ------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local fn = vim.fn
local lang = os.getenv("LTEX_LANG") or "en-US"

-- [[ imports ]] --------------------------------------------------------
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local fidget = require("fidget")
local formatters = require("conform")
local linters = require("lint")
local lsp_signature = require("lsp_signature")
local lspconfig = require("lspconfig")
local ltex_utils = require("ltex-utils")

-- [[ augroups ]] -------------------------------------------------------
local lsp_augroup = augroup("UserLspConfig", { clear = true })

-- [[ capabilities ]] ---------------------------------------------------
local capabilities = cmp_nvim_lsp.default_capabilities()

-- [[ ltex settings ]] --------------------------------------------------
ltex_utils.setup({
	opts = {
		dictionary = {
			use_vim_dict = true,
			vim_cmd_output = false,
		},
	},
})

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
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = {
					[fn.expand("$VIMRUNTIME/lua")] = true,
					[fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

lspconfig.ltex.setup({
	capabilities = capabilities,
	on_attach = function(_, bufnr)
		ltex_utils.on_attach(bufnr)
	end,
	settings = { ltex = { language = lang } },
})

-- [[ linters ]] --------------------------------------------------------
linters.linters_by_ft = {
	go = { "golangcilint" },
	nix = { "statix" },
	sh = { "shellcheck" },
	yaml = { "ansible_lint" },
}

autocmd("BufWritePost", {
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
	json = { "prettier" },
	lua = { "stylua" },
	markdown = { "prettier" },
	nix = { "alejandra" },
	python = { "ruff" },
	sh = { "shellharden" },
	terraform = { "terraform_fmt" },
	toml = { "taplo" },
	yaml = { "prettier" },
	go = { "gofumpt", "goimports", "golines" },
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
