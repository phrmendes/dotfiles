MiniDeps.now(function()
	MiniDeps.add({ source = "folke/snacks.nvim", depends = { "mini-nvim/mini.nvim" } })

	require("snacks").setup({
		input = { enabled = true },
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		words = { enabled = true },
		lazygit = { configure = false },
		terminal = { win = { wo = { winbar = "" } } },
		statuscolumn = { enabled = true, git = { patterns = { "MiniDiffSign" } } },
		image = { enabled = true },
	})
end)

vim.keymap.set("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Blame line" })
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "LazyGit" })
vim.keymap.set("n", "<leader>go", function() Snacks.gitbrowse() end, { desc = "Open in browser" })
vim.keymap.set({ "n", "t" }, "<c-\\>", function() Snacks.terminal() end, { desc = "Toggle terminal" })
