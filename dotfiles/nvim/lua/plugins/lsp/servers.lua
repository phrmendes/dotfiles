local utils = require("utils")
local schemastore = require("schemastore")
local python_ls

if vim.fn.executable("basedpyright-langserver") == 1 then
	python_ls = "basedpyright"
else
	python_ls = "pyright"
end

local servers = {
	{ server = python_ls },
	{ server = "ansiblels" },
	{ server = "bashls" },
	{ server = "cssls" },
	{ server = "docker_compose_language_service" },
	{ server = "dockerls" },
	{ server = "dotls" },
	{ server = "html" },
	{ server = "nixd" },
	{ server = "ruff_lsp" },
	{ server = "taplo" },
	{ server = "terraformls" },
	{ server = "texlab" },
	{ server = "tflint" },
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

for _, server in ipairs(servers) do
	utils.lsp.add_language_server(server)
end
