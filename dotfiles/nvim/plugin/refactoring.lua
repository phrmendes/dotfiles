later(function()
	vim.pack.add({
		"https://github.com/ThePrimeagen/refactoring.nvim",
		"https://github.com/nvim-lua/plenary.nvim",
	})

	require("refactoring").setup({})
end)
