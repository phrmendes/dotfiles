local utils = require("utils")

local efm = {
	css = { require("efmls-configs.formatters.prettier") },
	dockerfile = { require("efmls-configs.linters.hadolint") },
	go = {
		require("efmls-configs.linters.golangci_lint"),
		require("efmls-configs.formatters.gofumpt"),
		require("efmls-configs.formatters.goimports"),
		require("efmls-configs.formatters.golines"),
	},
	elixir = { require("efmls-configs.formatters.mix") },
	html = { require("efmls-configs.formatters.prettier") },
	htmldjango = { require("efmls-configs.linters.djlint"), require("efmls-configs.formatters.djlint") },
	javascript = { require("efmls-configs.formatters.prettier") },
	jinja2 = { require("efmls-configs.linters.djlint"), require("efmls-configs.formatters.djlint") },
	json = { require("efmls-configs.formatters.prettier") },
	lua = { require("efmls-configs.formatters.stylua") },
	markdown = { require("efmls-configs.formatters.prettier") },
	nix = { require("efmls-configs.formatters.alejandra") },
	python = { require("efmls-configs.formatters.ruff"), require("efmls-configs.formatters.ruff_sort") },
	scss = { require("efmls-configs.formatters.prettier") },
	sh = { require("efmls-configs.formatters.shellharden") },
	sql = { require("efmls-configs.formatters.sql-formatter") },
	terraform = { require("efmls-configs.formatters.terraform_fmt") },
	toml = { require("efmls-configs.formatters.taplo") },
	typescript = { require("efmls-configs.formatters.prettier") },
	yaml = { require("efmls-configs.formatters.prettier") },
}

utils.config_diagnostics({ Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }, {
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		source = "always",
		border = require("utils").borders.border,
	},
})

local servers = {
	ansiblels = {},
	bashls = {},
	cssls = {},
	dockerls = {},
	dotls = {},
	emmet_language_server = {},
	eslint = {},
	html = {},
	nil_ls = {},
	ruff = {},
	taplo = {},
	terraformls = {},
	texlab = {},
}

servers.basedpyright = {
	on_attach = function(_, bufnr)
		require("keymaps").dap(bufnr)
		require("keymaps").python(bufnr)
	end,
}

servers.efm = {
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
	},
	filetypes = vim.tbl_keys(efm),
	settings = {
		rootMarkers = { ".git/" },
		languages = efm,
	},
}

servers.elixirls = {
	cmd = { vim.fn.exepath("elixir-ls") },
	on_attach = function(_, bufnr)
		require("keymaps").dap(bufnr)
	end,
}

servers.gopls = {
	on_attach = function(client, bufnr)
		require("keymaps").dap(bufnr)

		if not client.server_capabilities.semanticTokensProvider then
			local semantic = client.config.capabilities.textDocument.semanticTokens
			client.server_capabilities.semanticTokensProvider = {
				full = true,
				legend = {
					tokenTypes = semantic.tokenTypes,
					tokenModifiers = semantic.tokenModifiers,
				},
				range = true,
			}
		end
	end,
	settings = {
		gopls = {
			gofumpt = true,
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			analyses = {
				fieldalignment = true,
				nilness = true,
				unusedparams = true,
				unusedwrite = true,
				useany = true,
			},
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = { "-.git", "-node_modules" },
			semanticTokens = true,
		},
	},
}

servers.helm_ls = {
	settings = {
		["helm-ls"] = {
			yamlls = {
				enabled = false,
			},
		},
	},
}
servers.jsonls = {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
}

servers.lua_ls = {
	on_attach = function(_, bufnr)
		require("keymaps").dap(bufnr)
	end,
	settings = {
		Lua = {
			completion = { callSnippet = "Replace" },
			diagnostics = {
				globals = { "vim", "_" },
				disable = { "missing-fields" },
			},
			telemetry = { enable = false },
		},
	},
}

servers.ltex = {
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
}

servers.tailwindcss = {
	settings = {
		tailwindCSS = {
			includeLanguages = {
				elixir = "html-eex",
				eelixir = "html-eex",
				heex = "html-eex",
			},
		},
	},
}

servers.ts_ls = {
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = require("paths.vue-language-server"),
				languages = { "javascript", "typescript", "vue" },
				configNamespace = "typescript",
				enableForWorkspaceTypeScriptVersions = true,
			},
		},
		filetypes = { "javascript", "typescript", "vue" },
	},
}

servers.volar = {
	init_options = {
		vue = {
			hybridMode = true,
		},
	},
}

servers.yamlls = {
	on_attach = function(_, bufnr)
		if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
			vim.diagnostic.enable(false, { bufnr = bufnr })

			vim.defer_fn(function()
				vim.diagnostic.reset(nil, bufnr)
			end, 1000)
		end
	end,
	settings = {
		yaml = {
			schemas = require("schemastore").yaml.schemas(),
			schemaStore = {
				enable = false,
				url = "",
			},
		},
	},
}

for key, value in pairs(servers) do
	utils.config_server({
		server = key,
		settings = value,
	})
end
