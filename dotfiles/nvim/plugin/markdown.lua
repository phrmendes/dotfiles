MiniDeps.later(function()
	MiniDeps.add({ source = "tadmccorkle/markdown.nvim" })
	MiniDeps.add({ source = "brianhuster/live-preview.nvim" })

	require("markdown").setup({ on_attach = function(bufnr) require("keymaps.markdown")(bufnr) end })
end)
