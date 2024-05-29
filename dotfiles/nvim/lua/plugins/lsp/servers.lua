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

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

local servers = {
	ansiblels = {},
	basedpyright = {},
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
	markdown_oxide = {
		on_attach = function(_, bufnr)
			vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "LspAttach" }, {
				buffer = bufnr,
				callback = vim.lsp.codelens.refresh,
			})

			vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
		end,
	},
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
}

for key, value in pairs(servers) do
	(function(server_name, settings)
		local setup = settings or {}

		setup.capabilities = vim.tbl_deep_extend("force", {}, capabilities, setup.capabilities or {})
		setup.flags = vim.tbl_deep_extend("force", {}, flags, setup.flags or {})
		setup.handlers = vim.tbl_deep_extend("force", {}, handlers, setup.handlers or {})

		require("lspconfig")[server_name].setup(setup)
	end)(key, value)
end
