require("markdown").setup({
	on_attach = function(bufnr)
		require("keymaps").markdown(bufnr)
	end,
})

vim.g.markdown_fenced_languages = { "ts=typescript" }
