local add, later = MiniDeps.add, MiniDeps.later

later(function()
	add({
		source = "ThePrimeagen/refactoring.nvim",
		depends = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
	})

	require("refactoring").setup({
		prompt_func_return_type = { go = true },
		prompt_func_param_type = { go = true },
	})
end)
