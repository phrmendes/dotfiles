local add, now = MiniDeps.add, MiniDeps.now
local map = vim.keymap.set

now(function()
	add({ source = "mrjones2014/smart-splits.nvim" })

	require("smart-splits").setup({ cursor_follows_swapped_bufs = true })

	map({ "n", "t" }, "<a-h>", function() require("smart-splits").resize_left() end)
	map({ "n", "t" }, "<a-j>", function() require("smart-splits").resize_down() end)
	map({ "n", "t" }, "<a-k>", function() require("smart-splits").resize_up() end)
	map({ "n", "t" }, "<a-l>", function() require("smart-splits").resize_right() end)
	map({ "n", "t" }, "<c-h>", function() require("smart-splits").move_cursor_left() end)
	map({ "n", "t" }, "<c-j>", function() require("smart-splits").move_cursor_down() end)
	map({ "n", "t" }, "<c-k>", function() require("smart-splits").move_cursor_up() end)
	map({ "n", "t" }, "<c-l>", function() require("smart-splits").move_cursor_right() end)
	map("n", "<c-left>", function() require("smart-splits").swap_buf_left() end)
	map("n", "<c-down>", function() require("smart-splits").swap_buf_down() end)
	map("n", "<c-up>", function() require("smart-splits").swap_buf_up() end)
	map("n", "<c-right>", function() require("smart-splits").swap_buf_right() end)
end)
