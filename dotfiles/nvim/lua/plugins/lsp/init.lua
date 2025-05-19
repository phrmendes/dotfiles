return {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = { "b0o/SchemaStore.nvim" },
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
			gopls = {},
			html = {},
			marksman = {},
			nixd = {},
			ruff = {},
			taplo = {},
			terraformls = {},
			vtsls = {},
			helm_ls = require("plugins.lsp.helm-ls"),
			jsonls = require("plugins.lsp.jsonls"),
			ltex_plus = require("plugins.lsp.ltex-plus"),
			lua_ls = require("plugins.lsp.lua-ls"),
			scls = require("plugins.lsp.scls"),
			yamlls = require("plugins.lsp.yamlls"),
		}

		vim.iter(pairs(servers)):each(function(server, config)
			if vim.tbl_isempty(config) then return end
			vim.lsp.config(server, config)
		end)

		vim.lsp.enable(vim.tbl_keys(servers))
	end,
}
