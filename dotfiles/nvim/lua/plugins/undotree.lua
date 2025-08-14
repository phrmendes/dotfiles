MiniDeps.later(function() MiniDeps.add({ source = "mbbill/undotree" }) end)

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo Tree" })
