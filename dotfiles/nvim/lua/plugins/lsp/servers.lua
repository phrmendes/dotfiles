local schemastore = require("schemastore")
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

local flags = {
	allow_incremental_sync = true,
	debounce_text_changes = 150,
}

local servers = {
	ansiblels = {},
	bashls = {},
	cssls = {},
	docker_compose_language_service = {},
	dockerls = {},
	dotls = {},
	html = {},
	nil_ls = {},
	ruff_lsp = {},
	taplo = {},
	terraformls = {},
	texlab = {},
	tflint = {
		settings = {
			["helm-ls"] = {
				yamlls = {
					enable = false,
				},
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
	yamlls = {
		settings = {
			yaml = {
				validate = true,
				schemaStore = {
					enable = false,
					url = "",
				},
				schemas = schemastore.yaml.schemas({
					select = {
						".pre-commit-hooks.yml",
						"Azure Pipelines",
						"GitHub Action",
						"GitHub Workflow",
						"Helm Chart.lock",
						"Helm Chart.yaml",
						"Hugo",
						"docker-compose.yml",
					},
				}),
			},
		},
	},
	jsonls = {
		filetypes = { "json" },
		settings = {
			json = {
				schemas = schemastore.json.schemas(),
				validate = { enable = true },
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
}

if vim.fn.executable("basedpyright") == 1 then
	servers.basedpyright = {}
else
	servers.pyright = {}
end

for key, value in pairs(servers) do
	(function(server_name, settings)
		local setup = {}

		setup.capabilities = vim.tbl_deep_extend("force", {}, capabilities, settings.capabilities or {})
		setup.flags = vim.tbl_deep_extend("force", {}, flags, settings.flags or {})
		setup.handlers = vim.tbl_deep_extend("force", {}, handlers, settings.handlers or {})
		setup.on_attach = function()
			settings.on_attach()
		end

		require("lspconfig")[server_name].setup(setup)
	end)(key, value)
end
