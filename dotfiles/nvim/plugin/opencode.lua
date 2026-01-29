later(function()
	vim.pack.add({ "https://github.com/NickvanDyke/opencode.nvim" })

	vim.g.opencode_opts = {
		provider = {
			enabled = "kitty",
			kitty = { location = "tab" },
		},
	}

	vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, {
		desc = "Ask",
	})

	vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end, {
		desc = "Execute action",
	})

	vim.keymap.set({ "n", "t" }, "<c-.>", function() require("opencode").toggle() end, {
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
end)
