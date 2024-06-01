local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

capabilities.workspace = {
	didChangeWatchedFiles = {
		dynamicRegistration = true,
	},
}

local flags = {
	allow_incremental_sync = true,
	debounce_text_changes = 150,
}

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

local languages = {
	nix = {
		require("efmls-configs.linters.statix"),
		require("efmls-configs.formatters.alejandra"),
	},
	sh = {
		require("efmls-configs.linters.shellcheck"),
		require("efmls-configs.formatters.shellharden"),
	},
	sql = {
		require("efmls-configs.linters.sqlfluff"),
	},
	jinja = {
		require("efmls-configs.linters.djlint"),
	},
	go = {
		require("efmls-configs.linters.golangci_lint"),
		require("efmls-configs.formatters.gofmt"),
		require("efmls-configs.formatters.goimports"),
		require("efmls-configs.formatters.golines"),
	},
	html = {
		require("efmls-configs.formatters.prettier_d"),
	},
	css = {
		require("efmls-configs.formatters.prettier_d"),
	},
	json = {
		require("efmls-configs.linters.jq"),
	},
	lua = {
		require("efmls-configs.formatters.stylua"),
	},
	python = {
		require("efmls-configs.formatters.ruff"),
	},
	terraform = {
		require("efmls-configs.formatters.terraform_fmt"),
	},
	toml = {
		require("efmls-configs.formatters.taplo"),
	},
	yaml = {
		require("efmls-configs.linters.ansible_lint"),
		require("efmls-configs.formatters.yq"),
	},
}

local servers = {
	ansiblels = {},
	basedpyright = {},
	bashls = {},
	cssls = {},
	docker_compose_language_service = {},
	dockerls = {},
	dotls = {},
	gopls = {},
	html = {},
	markdown_oxide = {},
	nil_ls = {},
	ruff = {},
	taplo = {},
	terraformls = {},
	texlab = {},
	tflint = {},
	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	yamlls = {
		settings = {
			yaml = {
				schemaStore = {
					enable = false,
					url = "",
				},
				schemas = require("schemastore").yaml.schemas(),
			},
		},
	},
	helm_ls = {
		settings = {
			["helm-ls"] = {
				yamlls = { enabled = false },
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
	efm = {
		filetypes = vim.tbl_keys(languages),
		init_options = {
			documentFormatting = true,
			documentRangeFormatting = true,
		},
		settings = {
			rootMarkers = { ".git/" },
			languages = languages,
		},
	},
}

for key, value in pairs(servers) do
	(function(server_name, settings)
		local setup = settings or {}

		setup.capabilities = vim.tbl_deep_extend("force", {}, capabilities, setup.capabilities or {})
		setup.flags = vim.tbl_deep_extend("force", {}, flags, setup.flags or {})
		setup.handlers = vim.tbl_deep_extend("force", {}, handlers, setup.handlers or {})

		require("lspconfig")[server_name].setup(setup)
	end)(key, value)
end
