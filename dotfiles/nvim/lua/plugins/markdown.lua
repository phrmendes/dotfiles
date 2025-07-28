MiniDeps.later(function()
	MiniDeps.add({ source = "tadmccorkle/markdown.nvim" })
	MiniDeps.add({ source = "davidmh/mdx.nvim", depends = { "nvim-treesitter/nvim-treesitter" } })

	local build = MiniDeps.later(function() vim.fn["mkdp#util#install"]() end)

	MiniDeps.add({
		source = "iamcco/markdown-preview.nvim",
		hooks = {
			post_install = build,
			post_checkout = build,
		},
	})

	MiniDeps.add({
		source = "MeanderingProgrammer/render-markdown.nvim",
		depends = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
	})

	require("markdown").setup({
		on_attach = function(bufnr) require("keymaps.markdown")(bufnr) end,
	})

	require("render-markdown").setup({
		completions = { lsp = { enabled = true } },
		heading = { position = "inline" },
		file_types = { "markdown", "quarto", "copilot-chat" },
	})

	require("mdx").setup()
end)
