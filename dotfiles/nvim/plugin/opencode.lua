MiniDeps.later(function()
	MiniDeps.add({ source = "NickvanDyke/opencode.nvim" })

	vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, {
		desc = "Ask",
	})

	vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end, {
		desc = "Execute action",
	})

	vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end, {
		desc = "Toggle opencode",
	})

	vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end, {
		expr = true,
		desc = "Add range to opencode",
	})

	vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end, {
		expr = true,
		desc = "Add line to opencode",
	})

	vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end, {
		desc = "Half page up (opencode)",
	})

	vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, {
		desc = "Half page down (opencode)",
	})
end)
