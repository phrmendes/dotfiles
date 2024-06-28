require("yanky").setup({
	ring = { storage = "sqlite" },
	preserve_cursor_position = { enabled = true },
	highlight = {
		on_put = true,
		on_yank = true,
		timer = 200,
	},
})
