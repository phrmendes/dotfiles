local map = vim.keymap.set
local helpers_mini = require("helpers.mini")

MiniDeps.add({
	source = "echasnovski/mini.nvim",
	depends = {
		"folke/snacks.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
})

require("helpers").load_plugins(vim.env.HOME .. "/.config/nvim/lua/plugins/mini")

map("n", "<c-p>", function() helpers_mini.pick.buffers() end, { desc = "Buffers" })
map("n", "<leader>/", function() MiniPick.builtin.grep_live() end, { desc = "Live grep" })
map("n", "<leader>?", function() MiniPick.builtin.help() end, { desc = "Help" })
map("n", "<leader>=", function() MiniMisc.resize_window() end, { noremap = true, desc = "Resize to default size" })
map("n", "<leader><leader>", function() MiniPick.builtin.files() end, { desc = "Files" })
map("n", "<leader><del>", function() MiniNotify.clear() end, { desc = "Clear notifications" })
map("n", "<leader>K", function() MiniExtra.pickers.keymaps() end, { desc = "Keymaps" })
map("n", "<leader>N", function() MiniNotify.show_history() end, { desc = "Notifications" })
map("n", "<leader>bd", function() MiniBufremove.delete() end, { desc = "Delete" })
map("n", "<leader>bw", function() MiniBufremove.wipeout() end, { desc = "Wipeout" })
map("n", "<leader>e", function() helpers_mini.files.open() end, { desc = "Explorer" })
map("n", "<leader>gA", "<cmd>Git add --all<cr>", { desc = "Add (repo)" })
map("n", "<leader>gL", function() MiniExtra.pickers.git_commits() end, { desc = "Log (repo)" })
map("n", "<leader>gP", "<cmd>Git push<cr>", { desc = "Push" })
map("n", "<leader>ga", "<cmd>Git add %<cr>", { desc = "Add (file)" })
map("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Commit" })
map("n", "<leader>gd", function() MiniDiff.toggle_overlay(0) end, { desc = "Diff (file)" })
map("n", "<leader>gh", function() MiniExtra.pickers.git_hunks() end, { desc = "Hunks" })
map("n", "<leader>gl", function() MiniExtra.pickers.git_commits() end, { desc = "Log (file)" })
map("n", "<leader>gp", "<cmd>Git pull<cr>", { desc = "Pull" })
map("n", "<leader>la", function() helpers_mini.visits.add_label() end, { desc = "Add" })
map("n", "<leader>ld", function() helpers_mini.visits.remove_label() end, { desc = "Delete" })
map("n", "<leader>ll", function() MiniExtra.pickers.visit_labels() end, { desc = "List" })
map("n", "<leader>m", function() MiniExtra.pickers.marks() end, { desc = "Marks" })
map("n", "<leader>v", function() MiniExtra.pickers.visit_paths() end, { desc = "Visits" })
map("n", "<leader>z", function() MiniMisc.zoom() end, { desc = "Zoom" })
map({ "n", "x" }, "<leader>gs", function() MiniGit.show_at_cursor({ split = "horizontal" }) end, {
	desc = "Show at cursor",
})
