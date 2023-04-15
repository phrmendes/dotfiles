local api = vim.api
local lsp = vim.lsp

local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters
local augroup = api.nvim_create_augroup("LspFormatting", {}) -- to setup format on save

null_ls.setup({
	-- linters and formatters
	sources = {
		diagnostics.pylint, -- python
		diagnostics.shellcheck, -- bash
		diagnostics.luacheck, -- lua
		formatting.autoflake, -- python
		formatting.isort, -- python
		formatting.black, -- python
		formatting.jq, -- json
		formatting.nixfmt, -- nix
		formatting.prettier, -- markdown
		formatting.shfmt, -- bash
		formatting.stylua, -- lua
	},
	-- configure format on save
	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp.buf.format({
						filter = function(client)
							--  only use null-ls for formatting instead of lsp server
							return client.name == "null-ls"
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
