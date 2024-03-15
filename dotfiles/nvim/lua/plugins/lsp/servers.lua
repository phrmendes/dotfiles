local utils = require("utils")
local schemastore = require("schemastore")

local capabilities_snippets = vim.lsp.protocol.make_client_capabilities()
capabilities_snippets.textDocument.completion.completionItem.snippetSupport = true

local servers = {
	{ server = "ansiblels" },
	{ server = "bashls" },
	{ server = "docker_compose_language_service" },
	{ server = "dockerls" },
	{ server = "nixd" },
	{ server = "ruff_lsp" },
	{ server = "terraformls" },
	{ server = "texlab" },
	{ server = "tflint" },
	{ server = "dotls" },
	{ server = "html", capabilities = capabilities_snippets },
	{ server = "cssls", capabilities = capabilities_snippets },
	{
		server = "taplo",
		settings = {
			evenBetterToml = {
				schema = {
					associations = {
						["ruff\\.toml$"] = "https://json.schemastore.org/ruff.json",
						["pyproject\\.toml$"] = "https://json.schemastore.org/pyproject.json",
					},
				},
			},
		},
	},
	{
		server = "helm_ls",
		settings = {
			["helm-ls"] = {
				yamlls = {
					enable = false,
				},
			},
		},
	},
	{
		server = "lua_ls",
		settings = {
			Lua = {
				completion = { callSnippet = "Replace" },
				diagnostics = { globals = { "vim" } },
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
	{
		server = "pyright",
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
	},
	{
		server = "yamlls",
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
	{
		server = "jsonls",
		capabilities = capabilities_snippets,
		filetypes = { "json" },
		settings = {
			json = {
				schemas = schemastore.json.schemas(),
				validate = { enable = true },
			},
		},
	},
	{
		server = "ltex",
		filetypes = { "markdown", "quarto" },
		on_attach = function()
			require("ltex_extra").setup({
				init_check = true,
				load_langs = { "en-US", "pt-BR" },
				path = vim.fn.expand("~/.local/state/ltex"),
			})
		end,
		settings = {
			ltex = {
				language = "none",
			},
		},
	},
}

for _, server in ipairs(servers) do
	utils.lsp.add_language_server(server)
end
