MiniDeps.now(function()
	require("notes").setup({ path = vim.env.HOME .. "/Documents/notes", picker = "mini" })

	vim.keymap.set("n", "<leader>ns", function() require("notes").search() end, { desc = "Search" })
	vim.keymap.set("n", "<leader>n/", function() require("notes").grep_live() end, { desc = "Live grep" })
	vim.keymap.set("n", "<leader>nn", function() require("notes").new() end, { desc = "New" })
end)
