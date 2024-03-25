local augroup = require("utils").augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
	group = augroup,
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
