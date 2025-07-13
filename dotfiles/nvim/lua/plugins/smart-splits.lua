local map = vim.keymap.set

MiniDeps.now(function()
	MiniDeps.add({ source = "mrjones2014/smart-splits.nvim" })

	local smart_splits = require("smart-splits")

	smart_splits.setup({ cursor_follows_swapped_bufs = true })

	map({ "n", "t" }, "<a-h>", function() smart_splits.resize_left() end)
	map({ "n", "t" }, "<a-j>", function() smart_splits.resize_down() end)
	map({ "n", "t" }, "<a-k>", function() smart_splits.resize_up() end)
	map({ "n", "t" }, "<a-l>", function() smart_splits.resize_right() end)
	map({ "n", "t" }, "<c-h>", function() smart_splits.move_cursor_left() end)
	map({ "n", "t" }, "<c-j>", function() smart_splits.move_cursor_down() end)
	map({ "n", "t" }, "<c-k>", function() smart_splits.move_cursor_up() end)
	map({ "n", "t" }, "<c-l>", function() smart_splits.move_cursor_right() end)
	map("n", "<c-left>", function() smart_splits.swap_buf_left() end)
	map("n", "<c-down>", function() smart_splits.swap_buf_down() end)
	map("n", "<c-up>", function() smart_splits.swap_buf_up() end)
	map("n", "<c-right>", function() smart_splits.swap_buf_right() end)
end)
