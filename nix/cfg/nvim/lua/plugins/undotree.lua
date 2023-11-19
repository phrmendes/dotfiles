local wk = require("which-key")

wk.register({
	u = { "<cmd>UndotreeToggle<cr>", "Toggle undo tree" },
}, { prefix = "<leader>", mode = "n" })
