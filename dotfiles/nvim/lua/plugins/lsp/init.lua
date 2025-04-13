return {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		"b0o/SchemaStore.nvim",
		"saghen/blink.cmp",
	},
	config = function()
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
			gopls = {},
			bibli_ls = require("plugins.lsp.bibli-ls"),
			elixirls = require("plugins.lsp.elixirls"),
			helm_ls = require("plugins.lsp.helm-ls"),
			jsonls = require("plugins.lsp.jsonls"),
			ltex_plus = require("plugins.lsp.ltex-plus"),
			lua_ls = require("plugins.lsp.lua-ls"),
			yamlls = require("plugins.lsp.yamlls"),
		}

		for server, config in pairs(servers) do
			if not vim.tbl_isempty(config) then vim.lsp.config(server, config) end

			vim.lsp.enable(server)
		end
	end,
}
