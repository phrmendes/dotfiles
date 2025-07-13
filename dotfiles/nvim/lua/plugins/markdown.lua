MiniDeps.later(function()
	MiniDeps.add({ source = "tadmccorkle/markdown.nvim" })
	MiniDeps.add({ source = "davidmh/mdx.nvim", depends = { "nvim-treesitter/nvim-treesitter" } })

	local build = function() vim.fn["mkdp#util#install"]() end

	MiniDeps.add({
		source = "iamcco/markdown-preview.nvim",
		hooks = {
			post_install = function() MiniDeps.later(build) end,
			post_checkout = build,
		},
	})

	require("markdown").setup({
		on_attach = function(bufnr) require("keymaps.markdown")(bufnr) end,
	})

	require("mdx").setup()
end)
