return {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		"b0o/SchemaStore.nvim",
	},
	config = function()
		local utils = require("utils")

		utils.config_diagnostics({ Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }, {
			virtual_text = false,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				source = "always",
				border = require("utils").borders.border,
			},
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

		for key, value in pairs(servers) do
			utils.config_lsp_server({
				server = key,
				config = value,
			})
		end
	end,
}
