local cmp_nvim_lsp = require("cmp_nvim_lsp")
local conform = require("conform")
local dap = require("dap")
local dap_python = require("dap-python")
local dap_ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")
local lightbulb = require("nvim-lightbulb")
local lint = require("lint")
local lsp_signature = require("lsp_signature")
local lspconfig = require("lspconfig")
local ltex_extra = require("ltex_extra")
local metals = require("metals")
local neodev = require("neodev")
local neotest = require("neotest")
local neotest_python = require("neotest-python")
local neotest_scala = require("neotest-scala")
local wk = require("which-key")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local metals_group = augroup("MetalsLspConfig", { clear = true })
local lint_group = augroup("LintersConfig", { clear = true })

-- [[ neodev ]] ---------------------------------------------------------
neodev.setup({
	library = { plugins = { "nvim-dap-ui" }, types = true },
})

-- [[ LSP utils ]] ------------------------------------------------------
lsp_signature.setup()

-- diagnostic icons
local diagnostics_signs = {
	Error = "",
	Warn = "",
	Hint = "",
	Info = "",
}

for type, icon in pairs(diagnostics_signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- [[ code actions ]] ---------------------------------------------------
lightbulb.setup({
	autocmd = { enabled = true },
})

-- [[ DAP ]] ------------------------------------------------------------
dap_ui.setup()
dap_virtual_text.setup()

dap_python.setup(vim.fn.expand("~") .. "/.virtualenvs/debugpy/bin/python")
dap_python.test_runner = "pytest"

dap.listeners.after.event_initialized["dapui_config"] = function()
	dap_ui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dap_ui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dap_ui.close()
end

dap.configurations.scala = {
	{
		type = "scala",
		request = "launch",
		name = "Run or test",
		metals = {
			runType = "runOrTestFile",
		},
	},
	{
		type = "scala",
		request = "launch",
		name = "Test target",
		metals = {
			runType = "testTarget",
		},
	},
}

-- [[ tests ]] ----------------------------------------------------------
neotest.setup({
	adapters = {
		neotest_python({
			dap = { justMyCode = false },
			runner = "pytest",
		}),
		neotest_scala({
			runner = "sbt",
		}),
	},
})

-- [[ linters ]] --------------------------------------------------------

lint.linters_by_ft = {
	nix = { "statix" },
	sh = { "shellcheck" },
}

autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_group,
	callback = function()
		lint.try_lint()
	end,
})

-- [[ formatters ]]	-----------------------------------------------------
conform.setup({
	format_on_save = {
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	},
})

conform.formatters.tex = {
	command = "latexindent.pl",
	args = { "-" },
	stdin = true,
}

conform.formatters_by_ft = {
	dart = { "dart_format" },
	json = { "prettier" },
	lua = { "stylua" },
	markdown = { "prettier" },
	nix = { "alejandra" },
	python = { "ruff" },
	sh = { "shellharden" },
	terraform = { "terraform_fmt" },
	toml = { "taplo" },
	yaml = { "prettier" },
}

-- [[ capabilities ]] ---------------------------------------------------
local capabilities = cmp_nvim_lsp.default_capabilities()

-- [[ on attach ]] ------------------------------------------------------
local on_attach = function(_, bufnr)
	wk.register({
		D = { vim.lsp.buf.declaration, "LSP: go to declaration" },
		d = { "<cmd>Telescope lsp_definitions<cr>", "LSP: go to definitions" },
		i = { "<cmd>Telescope lsp_implementations<cr>", "LSP: go to implementations" },
		r = { "<cmd>Telescope lsp_references<cr>", "LSP: go to references" },
		t = { "<cmd>Telescope lsp_type_definitions<cr>", "LSP: go to type definitions" },
	}, { prefix = "g", mode = "n", buffer = bufnr })

	wk.register({
		K = { vim.lsp.buf.signature_help, "LSP: show signature help" },
		S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "LSP: workspace symbols" },
		k = { vim.lsp.buf.hover, "LSP: show hover documentation" },
		r = { vim.lsp.buf.rename, "LSP: rename symbol" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "LSP: document symbols" },
		F = {
			function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end,
			"format",
		},
	}, { prefix = "<leader>", mode = "n", buffer = bufnr })

	wk.register({
		c = { dap.continue, "DAP: continue" },
		i = { dap.step_into, "DAP: step into" },
		o = { dap.step_over, "DAP: step over" },
		q = { dap.step_out, "DAP: step out" },
	}, { prefix = "<localleader>", mode = "n", buffer = bufnr })

	wk.register({
		name = "code",
		a = { vim.lsp.buf.code_action, "Actions" },
		l = { vim.lsp.codelens.run, "Lens" },
	}, { prefix = "<leader>c", mode = { "n", "x" }, buffer = bufnr })

	wk.register({
		name = "debug/diagnostics",
		b = { dap.toggle_breakpoint, "DAP: toggle breakpoint" },
		d = { "<cmd>TroubleToggle document_diagnostics<cr>", "LSP: document diagnostics" },
		f = { vim.diagnostic.open_float, "LSP: floating diagnostics message" },
		l = { dap.run_last, "DAP: run last" },
		t = { dap_ui.toggle, "DAP: toggle UI" },
		w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "LSP: workspace diagnostics" },
		B = {
			function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Breakpoint condition: "))
			end,
			"DAP: conditional breakpoint",
		},
	}, { prefix = "<leader>d", mode = "n", buffer = bufnr })

	wk.register({
		name = "tests",
		a = { neotest.run.attach, "Attach nearest test" },
		s = { neotest.run.stop, "Stop nearest test" },
		t = { neotest.run.run, "Run nearest test" },
		f = {
			function()
				neotest.run.run(vim.fn.expand("%"))
			end,
			"Run current file",
		},
		d = {
			function()
				neotest.run.run({ strategy = "dap" })
			end,
			"Debug nearest test",
		},
	}, { prefix = "<leader>t", mode = "n", buffer = bufnr })
end

-- [[ general servers configuration ]] ----------------------------------
local servers = {
	"ansiblels",
	"bashls",
	"dartls",
	"docker_compose_language_service",
	"dockerls",
	"helm_ls",
	"nil_ls",
	"ruff_lsp",
	"taplo",
	"terraformls",
	"texlab",
	"yamlls",
}

for _, server in ipairs(servers) do
	lspconfig[server].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

-- [[ specific servers configuration ]] ---------------------------------
lspconfig.jsonls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "vscode-json-languageserver", "--stdio" },
})

lspconfig.pyright.setup({
	capabilities = capabilities,
	on_attach = on_attach,
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
})

lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
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
})

-- [[ ltex ]] -----------------------------------------------------------
ltex_extra.setup({
	load_langs = { "en-US", "pt-BR" },
	init_check = true,
	path = vim.fn.expand("~") .. "/.local/state/ltex",
	server_opts = {
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "markdown", "quarto" },
	},
})

-- [[ metals ]] ---------------------------------------------------------
local metals_config = metals.bare_config()
metals_config.init_options.statusBarProvider = false
metals_config.capatibilities = capabilities

metals_config.on_attach = function()
	metals.setup_dap()
	on_attach()
end

metals_config.settings = {
	showImplicitArguments = true,
	showImplicitConversionsAndClasses = true,
	showInferredType = true,
	superMethodLensesEnabled = true,
	excludedPackages = {},
}

autocmd("FileType", {
	pattern = { "scala", "sbt", "java" },
	group = metals_group,
	callback = function()
		metals.initialize_or_attach(metals_config)

		wk.register({
			m = { metals.hover_worksheet, "Metals: worksheet" },
		}, { prefix = "<leader>", mode = "n" })
	end,
})
