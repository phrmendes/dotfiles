local map = vim.keymap.set

MiniDeps.now(function()
	require("notes").setup({ path = vim.env.HOME .. "/Documents/notes", picker = "mini" })

	map("n", "<leader>ns", function() require("notes").search() end, { desc = "Search" })
	map("n", "<leader>n/", function() require("notes").grep_live() end, { desc = "Live grep" })
	map("n", "<leader>nn", function() require("notes").new() end, { desc = "New" })
end)
