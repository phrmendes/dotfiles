MiniDeps.later(function()
	local keymap = require("mini.keymap")

	keymap.setup()
	keymap.map_multistep("i", "<tab>", { "minisnippets_next", "blink_next" })
	keymap.map_multistep("i", "<s-tab>", { "blink_prev", "minisnippets_prev" })
	keymap.map_multistep("i", "<cr>", { "pmenu_accept", "minipairs_cr" })
	keymap.map_multistep("i", "<bs>", { "minipairs_bs" })

	keymap.map_combo({ "i", "c", "x", "s" }, "jk", "<bs><bs><esc>")
	keymap.map_combo({ "i", "c", "x", "s" }, "kj", "<bs><bs><esc>")
	keymap.map_combo({ "i", "c", "x", "s", "n" }, "<esc><esc>", function() vim.cmd("nohlsearch") end)
end)
