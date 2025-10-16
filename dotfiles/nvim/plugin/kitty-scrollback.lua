MiniDeps.now(function()
	MiniDeps.add({ source = "mikesmithgh/kitty-scrollback.nvim" })
	require("kitty-scrollback").setup({
		{ status_window = { autoclose = true, style_simple = true }, keymaps_enable = false },
	})
end)
