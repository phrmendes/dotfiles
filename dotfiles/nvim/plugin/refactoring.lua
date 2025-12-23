later(function()
	vim.pack.add({
		"https://github.com/ThePrimeagen/refactoring.nvim",
		"https://github.com/nvim-lua/plenary.nvim",
	})

	require("refactoring").setup({
		prompt_func_return_type = { go = true },
		prompt_func_param_type = { go = true },
	})
end)
