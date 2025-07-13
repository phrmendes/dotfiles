local map = vim.keymap.set

MiniDeps.now(function()
	MiniDeps.add({ source = "folke/snacks.nvim", depends = { "echasnovski/mini.nvim" } })

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

	map("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Blame line" })
	map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "LazyGit" })
	map("n", "<leader>go", function() Snacks.gitbrowse() end, { desc = "Open in browser" })
	map({ "n", "t" }, "<c-\\>", function() Snacks.terminal() end, { desc = "Toggle terminal" })
end)
