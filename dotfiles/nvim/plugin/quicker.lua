later(function()
	vim.pack.add({ "https://github.com/stevearc/quicker.nvim" })

	require("quicker").setup({
		keys = {
			{
				">",
				function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end,
				desc = "Expand quickfix context",
			},
			{
				"<",
				function() require("quicker").collapse() end,
				desc = "Collapse quickfix context",
			},
		},
	})

	vim.keymap.set("n", "<leader>x", function() require("quicker").toggle() end, { noremap = true, desc = "Quickfix" })
end)
