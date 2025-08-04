local helpers_mini = require("helpers.mini")

MiniDeps.add({
	source = "echasnovski/mini.nvim",
	depends = {
		"folke/snacks.nvim",
		"nvim-treesitter/nvim-treesitter",
		"rafamadriz/friendly-snippets",
	},
})

require("helpers").load_plugins(vim.env.HOME .. "/.config/nvim/lua/plugins/mini")

vim.keymap.set("n", "<c-p>", function() helpers_mini.pick.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>/", function() MiniPick.builtin.grep_live() end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>?", function() MiniPick.builtin.help() end, { desc = "Help" })
vim.keymap.set("n", "<leader><leader>", function() MiniPick.builtin.files() end, { desc = "Files" })
vim.keymap.set("n", "<leader><del>", function() MiniNotify.clear() end, { desc = "Clear notifications" })
vim.keymap.set("n", "<leader>K", function() MiniExtra.pickers.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>N", function() MiniNotify.show_history() end, { desc = "Notifications" })
vim.keymap.set("n", "<leader>W", function() MiniMisc.setup_auto_root() end, { desc = "Change working dir" })
vim.keymap.set("n", "<leader>bd", function() MiniBufremove.delete() end, { desc = "Delete" })
vim.keymap.set("n", "<leader>bw", function() MiniBufremove.wipeout() end, { desc = "Wipeout" })
vim.keymap.set("n", "<leader>e", function() helpers_mini.files.open() end, { desc = "Explorer" })
vim.keymap.set("n", "<leader>gA", "<cmd>Git add --all<cr>", { desc = "Add (repo)" })
vim.keymap.set("n", "<leader>gL", function() MiniExtra.pickers.git_commits() end, { desc = "Log (repo)" })
vim.keymap.set("n", "<leader>gP", "<cmd>Git push<cr>", { desc = "Push" })
vim.keymap.set("n", "<leader>ga", "<cmd>Git add %<cr>", { desc = "Add (file)" })
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Commit" })
vim.keymap.set("n", "<leader>gd", function() MiniDiff.toggle_overlay(0) end, { desc = "Diff (file)" })
vim.keymap.set("n", "<leader>gh", function() MiniExtra.pickers.git_hunks() end, { desc = "Hunks" })
vim.keymap.set("n", "<leader>gl", function() MiniExtra.pickers.git_commits() end, { desc = "Log (file)" })
vim.keymap.set("n", "<leader>gp", "<cmd>Git pull<cr>", { desc = "Pull" })
vim.keymap.set("n", "<leader>m", function() MiniExtra.pickers.marks() end, { desc = "Marks" })
vim.keymap.set("n", "<leader>v", function() MiniExtra.pickers.visit_paths() end, { desc = "Visits" })
vim.keymap.set("n", "<leader>z", function() MiniMisc.zoom() end, { desc = "Zoom" })

vim.keymap.set("n", "<leader>=", function() MiniMisc.resize_window() end, {
	noremap = true,
	desc = "Resize to default size",
})

vim.keymap.set({ "n", "x" }, "<leader>gs", function() MiniGit.show_at_cursor({ split = "horizontal" }) end, {
	desc = "Show at cursor",
})
