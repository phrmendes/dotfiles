local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
	group = require("utils").augroups.lsp.attach,
	callback = function()
		require("neogen").setup({
			snippet_engine = "luasnip",
			enabled = true,
			languages = {
				python = {
					template = {
						annotation_convention = "numpydoc",
					},
				},
			},
		})
	end,
})
