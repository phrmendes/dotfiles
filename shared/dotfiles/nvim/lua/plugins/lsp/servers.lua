local utils = require("utils")
local schemastore = require("schemastore")

local capabilities_snippets = vim.lsp.protocol.make_client_capabilities()
capabilities_snippets.textDocument.completion.completionItem.snippetSupport = true

local servers = {
	{ server = "ansiblels" },
	{ server = "bashls" },
	{ server = "docker_compose_language_service" },
	{ server = "dockerls" },
	{ server = "golangci_lint_ls" },
	{ server = "nixd" },
	{ server = "ruff_lsp" },
	{ server = "terraformls" },
	{ server = "texlab" },
	{ server = "tflint" },
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
						"bashly.yml",
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
}

if vim.fn.has("mac") == 0 then
	servers = vim.tbl_extend("keep", servers, {
		{ server = "htmx" },
		{ server = "tailwindcss", filetypes = { "html", "css" } },
	})
else
	servers = vim.tbl_extend("keep", servers, {
		{ server = "marksman" },
	})
end

for _, server in ipairs(servers) do
	utils.add_language_server(server)
end
