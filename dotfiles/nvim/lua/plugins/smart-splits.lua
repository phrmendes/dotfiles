return {
	"mrjones2014/smart-splits.nvim",
	opts = {
		cursor_follows_swapped_bufs = true,
	},
	init = function()
		vim.keymap.set({ "n", "t" }, "<a-h>", function() require("smart-splits").resize_left() end)
		vim.keymap.set({ "n", "t" }, "<a-j>", function() require("smart-splits").resize_down() end)
		vim.keymap.set({ "n", "t" }, "<a-k>", function() require("smart-splits").resize_up() end)
		vim.keymap.set({ "n", "t" }, "<a-l>", function() require("smart-splits").resize_right() end)
		vim.keymap.set({ "n", "t" }, "<c-h>", function() require("smart-splits").move_cursor_left() end)
		vim.keymap.set({ "n", "t" }, "<c-j>", function() require("smart-splits").move_cursor_down() end)
		vim.keymap.set({ "n", "t" }, "<c-k>", function() require("smart-splits").move_cursor_up() end)
		vim.keymap.set({ "n", "t" }, "<c-l>", function() require("smart-splits").move_cursor_right() end)
		vim.keymap.set("n", "<c-left>", function() require("smart-splits").swap_buf_left() end)
		vim.keymap.set("n", "<c-down>", function() require("smart-splits").swap_buf_down() end)
		vim.keymap.set("n", "<c-up>", function() require("smart-splits").swap_buf_up() end)
		vim.keymap.set("n", "<c-right>", function() require("smart-splits").swap_buf_right() end)
	end,
}
