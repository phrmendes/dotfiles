-- [[ variables ]] ------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local buf = vim.lsp.buf
local diag = vim.diagnostic
local lsp = vim.lsp
local map = vim.keymap.set

-- [[ imports ]] --------------------------------------------------------
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local fidget = require("fidget")
local formatters = require("conform")
local linters = require("lint")
local lsp_signature = require("lsp_signature")
local lspconfig = require("lspconfig")
local ltex = require("ltex_extra")
local telescope_builtin = require("telescope.builtin")
local wk = require("which-key")

-- [[ augroups ]] -------------------------------------------------------
local lsp_augroup = augroup("LspSettings", { clear = true })

-- [[ functions ]] ------------------------------------------------------
local section = function(key, name, prefix, mode)
    wk.register({
        [key] = { name = name },
    }, { prefix = prefix, mode = mode })
end

-- [[ capabilities ]] ---------------------------------------------------
local capabilities = cmp_nvim_lsp.default_capabilities()

-- [[ on attatch ]] -----------------------------------------------------
local on_attach = function()
	map("n", "K", buf.hover, { desc = "Show hover [LSP]" })
	map("n", "[d", diag.goto_prev, { desc = "Previous diagnostic message" })
	map("n", "]d", diag.goto_next, { desc = "Next diagnostic message" })
	map("n", "gD", buf.declaration, { desc = "Go to declaration [LSP]" })
	map("n", "gR", telescope_builtin.lsp_references, { desc = "Go to references [LSP]" })
	map("n", "gd", telescope_builtin.lsp_definitions, { desc = "Go to definition [LSP]" })
	map("n", "gi", telescope_builtin.lsp_implementations, { desc = "Go to implementation [LSP]" })
	map("n", "gr", buf.rename, { desc = "Rename [LSP]" })
	map("n", "gs", buf.signature_help, { desc = "Signature help [LSP]" })

	section("ca", "code action [LSP]", "<localleader>", { "n", "v" })
	map({ "n", "v" }, "<localleader>ca", buf.code_action, { desc = "Show available code actions" })

	section("l", "lsp", "<localleader>", "n")
	map("n", "<leader>lc", lsp.codelens.run, { desc = "Run code lens" })
	map("n", "<leader>ld", telescope_builtin.diagnostics, { desc = "Diagnostics" })
	map("n", "<leader>lf", formatters.format, { desc = "Format buffer" })
	map("n", "<leader>ll", diag.loclist, { desc = "Loclist" })
	map("n", "<leader>lo", diag.open_float, { desc = "Open floating diagnostic message" })
	map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart" })
	map("n", "<leader>ls", telescope_builtin.lsp_document_symbols, { desc = "Document symbols" })
	map("n", "<leader>lw", telescope_builtin.lsp_document_symbols, { desc = "Workspace symbols" })
end

-- [[ general servers configuration ]] ----------------------------------
local servers = {
	"ansiblels",
	"bashls",
	"dockerls",
	"metals",
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
	on_attach = on_attach,
	capabilities = capabilities,
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
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

ltex.setup({
	load_langs = { "en", "pt", "pt-BR" },
	init_check = true,
	path = ".ltex",
	server_opts = {
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			ltex = {
				language = "auto",
				additionalRules = {
					enablePickyRules = true,
					motherTongue = "pt-BR",
				},
			},
		},
	},
})

-- [[ linters ]] --------------------------------------------------------
linters.linters_by_ft = {
	sh = { "shellcheck" },
	nix = { "statix" },
	ansible = { "ansible_lint" },
}

autocmd({ "BufWritePost" }, {
	group = lsp_augroup,
	callback = function()
		linters.try_lint()
	end,
})

-- [[ formatters ]] -----------------------------------------------------
formatters.formatters_by_ft = {
	json = { "prettier" },
	lua = { "stylua" },
	nix = { "alejandra" },
	python = { "ruff" },
	scala = { "scalafmt" },
	sh = { "shfmt" },
	terraform = { "terraform_fmt" },
	tex = { "latexindent" },
	toml = { "taplo" },
	yaml = { "prettier" },
}

-- [[ lsp utils ]] ------------------------------------------------------
-- nvim-lsp progress
fidget.setup()

-- set up lsp_signature
lsp_signature.setup()

local diagnostics_signs = {
	Error = " ",
	Warn = " ",
	Hint = "󱍄 ",
	Info = " ",
}

for type, icon in pairs(diagnostics_signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
