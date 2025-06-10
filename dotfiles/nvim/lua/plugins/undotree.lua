local add, later = MiniDeps.add, MiniDeps.later

later(function()
	add({ source = "mbbill/undotree" })

	vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo Tree" })
end)
