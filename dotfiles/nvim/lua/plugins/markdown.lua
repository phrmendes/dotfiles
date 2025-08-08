MiniDeps.later(function()
	MiniDeps.add({ source = "tadmccorkle/markdown.nvim" })
	MiniDeps.add({ source = "brianhuster/live-preview.nvim" })
	MiniDeps.add({ source = "davidmh/mdx.nvim", depends = { "nvim-treesitter/nvim-treesitter" } })

	require("markdown").setup({
		on_attach = function(bufnr) require("keymaps.markdown")(bufnr) end,
	})

	require("mdx").setup()
end)
