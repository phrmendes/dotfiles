local utils = require("utils")
local schemastore = require("schemastore")
local servers

servers = {
	{ server = "ansiblels" },
	{ server = "bashls" },
	{ server = "cssls" },
	{ server = "docker_compose_language_service" },
	{ server = "dockerls" },
	{ server = "helm_ls" },
	{ server = "nil_ls" },
	{ server = "ruff_lsp" },
	{ server = "taplo" },
	{ server = "terraformls" },
	{ server = "texlab" },
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
		capabilities = "markup",
		settings = {
			yaml = {
				keyOrdering = false,
				schemaStore = {
					enable = false,
					url = "",
				},
				schemas = schemastore.yaml.schemas(),
			},
		},
	},
	{
		server = "jsonls",
		capabilities = "markup",
		settings = {
			json = {
				schemas = schemastore.json.schemas(),
				validate = { enable = true },
			},
		},
	},
	{
		server = "html",
		capabilities = "markup",
	},
}

if vim.fn.has("mac") == 0 then
	servers = vim.tbl_extend("force", servers, {
		{ server = "tailwindcss" },
		{ server = "htmx" },
	})
else
	servers = vim.tbl_extend("force", servers, {
		{ server = "marksman" },
	})
end

for _, server in ipairs(servers) do
	utils.add_language_server(server)
end
