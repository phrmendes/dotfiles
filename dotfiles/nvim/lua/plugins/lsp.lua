local alejandra = require("efmls-configs.formatters.alejandra")
local hadolint = require("efmls-configs.linters.hadolint")
local prettier = require("efmls-configs.formatters.prettier")
local ruff = require("efmls-configs.linters.ruff")
local shellcheck = require("efmls-configs.linters.shellcheck")
local shellharden = require("efmls-configs.formatters.shellharden")
local sqlfluff = require("efmls-configs.linters.sqlfluff")
local stylua = require("efmls-configs.formatters.stylua")
local taplo = require("efmls-configs.formatters.taplo")
local terraform_fmt = require("efmls-configs.formatters.terraform_fmt")

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, require("utils").borders),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, require("utils").borders),
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

local languages = {
	nix = { alejandra },
	dockerfile = { hadolint },
	markdown = { prettier },
	json = { prettier },
	yaml = { prettier },
	css = { prettier },
	scss = { prettier },
	html = { prettier },
	sh = { shellcheck, shellharden },
	python = { ruff },
	toml = { taplo },
	lua = { stylua },
	terraform = { terraform_fmt },
	sql = { sqlfluff },
}

local servers = {
	ansiblels = {},
	autotools_ls = {},
	basedpyright = {},
	bashls = {},
	cssls = {},
	dockerls = {},
	dotls = {},
	emmet_language_server = {},
	html = {},
	nixd = {},
	ruff = {},
	taplo = {},
	terraformls = {},
	texlab = {},
	efm = {
		filetypes = vim.tbl_keys(languages),
		settings = {
			rootMarkers = { ".git/" },
			languages = languages,
		},
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
		},
	},
	helm_ls = {
		settings = {
			["helm-ls"] = {
				yamlls = { enabled = false },
			},
		},
	},
	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				completion = { callSnippet = "Replace" },
				diagnostics = {
					globals = { "vim" },
					disable = { "missing-fields" },
				},
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
	},
	ltex = {
		filetypes = { "markdown", "quarto" },
		on_attach = function()
			require("ltex_extra").setup({
				init_check = true,
				load_langs = { "en-US", "pt-BR" },
				path = vim.fn.stdpath("data") .. "/ltex-ls",
			})
		end,
		settings = {
			ltex = {
				language = "none",
			},
		},
	},
	yamlls = {
		settings = {
			yaml = {
				schemas = require("schemastore").yaml.schemas(),
				schemaStore = {
					enable = false,
					url = "",
				},
			},
		},
	},
}

for key, value in pairs(servers) do
	(function(server_name, settings)
		local setup = settings or {}

		setup.capabilities = vim.tbl_deep_extend("force", {}, capabilities, setup.capabilities or {})
		setup.handlers = vim.tbl_deep_extend("force", {}, handlers, setup.handlers or {})

		require("lspconfig")[server_name].setup(setup)
	end)(key, value)
end
