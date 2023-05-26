local api = vim.api
local lsp = vim.lsp

local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters
local code_actions = null_ls.builtins.code_actions -- to setup code actions
local augroup = api.nvim_create_augroup("LspFormatting", {}) -- to setup format on save

null_ls.setup({
	-- linters and formatters
	sources = {
		code_actions.gomodifytags, -- go
		code_actions.shellcheck, -- bash
		code_actions.statix, -- nix
		diagnostics.golangci_lint, -- go
		diagnostics.jsonlint, -- json
		diagnostics.luacheck, -- lua
		diagnostics.ruff, -- python
		diagnostics.shellcheck, -- bash
		diagnostics.statix, -- nix
		diagnostics.yamllint, -- yaml
		formatting.alejandra, -- nix
		formatting.gofumpt, -- go
		formatting.goimports, -- go
		formatting.golines, -- go
		formatting.nixfmt, -- nix
		formatting.prettier.with({ filetypes = { "markdown", "json", "yaml" } }),
		formatting.ruff, -- python
		formatting.shfmt, -- bash
		formatting.stylua, -- lua
	},
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
