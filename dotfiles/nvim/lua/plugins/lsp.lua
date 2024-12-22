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
	basedpyright = {},
	bashls = {},
	cssls = {},
	dockerls = {},
	dotls = {},
	emmet_language_server = {},
	eslint = {},
	gopls = {},
	html = {},
	marksman = {},
	nil_ls = {},
	ruff = {},
	taplo = {},
	terraformls = {},
	texlab = {},
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
	settings = {
		ltex = {
			checkFrequency = "save",
			language = "none",
			additionalRules = {
				enablePickyRules = true,
				motherTongue = "pt-BR",
			},
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
	utils.config_lsp_server({
		server = key,
		settings = value,
	})
end
