local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }

local capabilities = vim.lsp.protocol.make_client_capabilities()

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, require("utils").borders),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, require("utils").borders),
}

capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

capabilities.textDocument.completion.completionItem.snippetSupport = true

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

local servers = {
	ansiblels = {},
	bashls = {},
	cssls = {},
	dockerls = {},
	dotls = {},
	emmet_language_server = {},
	html = {},
	nixd = {},
	ruff = {},
	sqls = {},
	tailwindcss = {},
	taplo = {},
	terraformls = {},
	texlab = {},
}

servers.basedpyright = {
	on_attach = function(_, bufnr)
		require("keymaps").dap(bufnr)
		require("keymaps").python(bufnr)
		require("keymaps").refactoring(bufnr)
		require("keymaps").tests(bufnr)
	end,
}

servers.elixirls = {
	cmd = { vim.fn.exepath("elixir-ls") },
	on_attach = function(_, bufnr)
		require("keymaps").dap(bufnr)
		require("keymaps").tests(bufnr)
	end,
}

servers.gopls = {
	on_attach = function(_, bufnr)
		require("keymaps").dap(bufnr)
		require("keymaps").refactoring(bufnr)
		require("keymaps").tests(bufnr)
	end,
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
}
servers.ltex = {
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
	(function(server, settings)
		local setup = settings or {}

		setup.capabilities = vim.tbl_deep_extend("force", {}, capabilities, setup.capabilities or {})
		setup.handlers = vim.tbl_deep_extend("force", {}, handlers, setup.handlers or {})

		require("lspconfig")[server].setup(setup)
	end)(key, value)
end
