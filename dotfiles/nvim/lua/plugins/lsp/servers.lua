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

local servers = {
	ansiblels = {},
	bashls = {},
	cssls = {},
	docker_compose_language_service = {},
	dockerls = {},
	dotls = {},
	gopls = {},
	html = {},
	jsonls = {},
	nil_ls = {},
	ruff_lsp = {},
	taplo = {},
	terraformls = {},
	texlab = {},
	tflint = {},
	yamlls = {},
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
	markdown_oxide = {
		filetypes = { "markdown" },
		on_attach = function(_, bufnr)
			local group = require("utils").augroups.lsp
			vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "LspAttach" }, {
				group = group,
				buffer = bufnr,
				callback = vim.lsp.codelens.refresh,
			})
		end,
	},
}

if vim.fn.executable("basedpyright") == 1 then
	servers.basedpyright = {}
else
	servers.pyright = {}
end

for key, value in pairs(servers) do
	(function(server_name, settings)
		local setup = settings or {}

		setup.capabilities = vim.tbl_deep_extend("force", {}, capabilities, setup.capabilities or {})
		setup.flags = vim.tbl_deep_extend("force", {}, flags, setup.flags or {})

		require("lspconfig")[server_name].setup(setup)
	end)(key, value)
end
