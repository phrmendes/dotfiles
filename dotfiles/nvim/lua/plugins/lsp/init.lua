MiniDeps.now(function()
	MiniDeps.add({ source = "neovim/nvim-lspconfig", depends = { "b0o/SchemaStore.nvim" } })

	local servers = {
		basedpyright = {},
		bashls = {},
		cssls = {},
		dockerls = {},
		dotls = {},
		emmet_language_server = {},
		eslint = {},
		gopls = {},
		helm_ls = {},
		html = {},
		marksman = {},
		nixd = {},
		ruff = {},
		tailwindcss = {},
		taplo = {},
		terraformls = {},
		ts_ls = {},
		elixirls = require("plugins.lsp.elixir-ls"),
		astro = require("plugins.lsp.astro"),
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
end)
