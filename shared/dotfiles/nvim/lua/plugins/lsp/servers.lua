local utils = require("utils")
local schemastore = require("schemastore")
local conditional_servers

local servers = {
	{ server = "ansiblels" },
	{ server = "bashls" },
	{ server = "cssls" },
	{ server = "dockerls" },
	{ server = "html" },
	{ server = "nil_ls" },
	{ server = "ruff_lsp" },
	{ server = "terraformls" },
	{ server = "texlab" },
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
		server = "gopls",
		on_attach = function()
			require("plugins.dap").go()
		end,
	},
	{
		server = "pyright",
		on_attach = function()
			require("plugins.dap").python()
		end,
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
		setup = require("yaml-companion").setup({
			builtin_matchers = {
				kubernetes = { enabled = true },
			},
			schemas = {
				{
					name = "Argo CD Application",
					uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
				},
				{
					name = "Kustomization",
					uri = "https://json.schemastore.org/kustomization.json",
				},
				{
					name = "GitHub Workflow",
					uri = "https://json.schemastore.org/github-workflow.json",
				},
			},
			lspconfig = {
				on_attach = function(client, bufnr)
					utils.on_attach(client, bufnr)

					utils.map({
						key = "<leader>y",
						cmd = "<cmd>Telescope yaml_schema<cr>",
						desc = "YAML schemas",
						buffer = bufnr,
					})
				end,
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
								"bashly.yml",
								"docker-compose.yml",
								"Hugo",
							},
						}),
					},
				},
			},
		}),
	},
	{
		server = "jsonls",
		settings = {
			json = {
				schemas = schemastore.json.schemas(),
				validate = { enable = true },
			},
		},
	},
}

if vim.fn.has("mac") == 0 then
	conditional_servers = {
		{ server = "tailwindcss" },
		{ server = "htmx" },
	}
else
	conditional_servers = {
		{ server = "marksman" },
	}
end

servers = vim.tbl_extend("force", servers, conditional_servers)

for _, server in ipairs(servers) do
	utils.add_language_server(server)
end
