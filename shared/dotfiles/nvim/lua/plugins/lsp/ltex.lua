local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(_, bufnr)
	local map = function(key, value, desc, type)
		if key == nil then
			type = "n"
		end

		vim.keymap.set(type, key, value, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	map("<leader>a", vim.lsp.buf.code_action, "code actions", { "n", "x" })
	map("<leader>d", "<cmd>TroubleToggle document_diagnostics<cr>", "document diagnostics")
end

require("ltex_extra").setup({
	load_langs = { "en-US", "pt-BR" },
	init_check = false,
	path = vim.fn.expand("~") .. "/.local/state/ltex",
	server_opts = {
		on_attach = on_attach,
		capabilities = capabilities,
		filetypes = { "markdown", "quarto" },
		settings = {
			ltex = {
				language = "auto",
			},
		},
	},
})
