local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lsp_signature = require("lsp_signature")
local lspconfig = require("lspconfig")
local ltex = require("ltex_extra")
local linters = require("lint")
local formatters = require("conform")
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- lsp capabilities function
local capabilities = cmp_nvim_lsp.default_capabilities()

-- set up lsp_signature
lsp_signature.setup()

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

-- config language servers
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

lspconfig.jsonls.setup({
	capabilities = capabilities,
	cmd = { "vscode-json-languageserver", "--stdio" },
})

ltex.setup({
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

-- linters
linters.linters_by_ft = {
	sh = { "shellcheck" },
	nix = { "statix" },
	ansible = { "ansible_lint" },
}

local linter_group = augroup("LinterSettings", { clear = true })

autocmd({ "BufWritePost" }, {
	group = linter_group,
	callback = function()
		linters.try_lint()
	end,
})

-- formatters
formatters.setup({
	formatters_by_ft = {
		nix = { "alejandra" },
		lua = { "stylua" },
		python = { "ruff" },
		json = { "jq" },
		yaml = { "yamlfmt" },
		scala = { "scalafmt" },
		sh = { "shfmt" },
		toml = { "taplo" },
		terraform = { "terraform_fmt" },
		tex = { "latexindent" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
})
