return {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		"b0o/SchemaStore.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		local utils = require("utils")

		for type, icon in pairs({ Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		vim.diagnostic.config({
			virtual_text = false,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = { border = utils.borders.border },
		})

		local servers = {
			ansiblels = {},
			basedpyright = {},
			bashls = {},
			cssls = {},
			dockerls = {},
			dotls = {},
			emmet_language_server = {},
			eslint = {},
			html = {},
			marksman = {},
			nixd = {},
			ruff = {},
			taplo = {},
			terraformls = {},
			vtsls = {},
			bibli_ls = require("plugins.lsp.bibli-ls"),
			elixirls = require("plugins.lsp.elixirls"),
			helm_ls = require("plugins.lsp.helm-ls"),
			jsonls = require("plugins.lsp.jsonls"),
			ltex_plus = require("plugins.lsp.ltex-plus"),
			lua_ls = require("plugins.lsp.lua-ls"),
			yamlls = require("plugins.lsp.yamlls"),
		}

		for server, config in pairs(servers) do
			config.capabilities = require("blink.cmp").get_lsp_capabilities()

			config.handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, utils.borders),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, utils.borders),
			}

			require("lspconfig")[server].setup(config)
		end
	end,
}
