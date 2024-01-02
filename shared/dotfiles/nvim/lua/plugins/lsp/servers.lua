local utils = require("utils")
local schemastore = require("schemastore")

local servers = {
	{ server = "ansiblels" },
	{ server = "bashls" },
	{ server = "cssls" },
	{ server = "docker_compose_language_service" },
	{ server = "dockerls" },
	{ server = "helm_ls" },
	{ server = "marksman" },
	{ server = "nil_ls" },
	{ server = "ruff_lsp" },
	{ server = "tailwindcss" },
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
		capabilities = utils.lsp.simple.capabilities(),
		on_attach = utils.lsp.simple.on_attach,
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
		capabilities = utils.lsp.simple.capabilities(),
		on_attach = utils.lsp.simple.on_attach,
		settings = {
			json = {
				schemas = schemastore.json.schemas(),
				validate = { enable = true },
			},
		},
	},
	{
		server = "html",
		capabilities = utils.lsp.simple.capabilities(),
		on_attach = utils.lsp.simple.on_attach,
	},
	{
		server = "htmx",
		capabilities = nil,
		handlers = nil,
		on_attach = nil,
	},
}

for _, server in ipairs(servers) do
	utils.lsp.add_server(server)
end
