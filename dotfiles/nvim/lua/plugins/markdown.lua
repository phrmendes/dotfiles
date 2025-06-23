local add, later = MiniDeps.add, MiniDeps.later
local map = vim.keymap.set

later(function()
	add({ source = "tadmccorkle/markdown.nvim" })
	add({ source = "davidmh/mdx.nvim", depends = { "nvim-treesitter/nvim-treesitter" } })

	local build = function() vim.fn["mkdp#util#install"]() end

	add({
		source = "iamcco/markdown-preview.nvim",
		hooks = {
			post_install = function() later(build) end,
			post_checkout = build,
		},
	})

	require("markdown").setup({
		on_attach = function(bufnr) require("keymaps.markdown")(bufnr) end,
	})

	require("mdx").setup()
end)
