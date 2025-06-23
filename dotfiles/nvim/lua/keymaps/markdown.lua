local map = vim.keymap.set

return function(bufnr)
	map({ "n", "i" }, "<c-c>k", "<Cmd>MDListItemAbove<CR>", { buffer = bufnr, desc = "markdown: add item above" })
	map({ "n", "i" }, "<c-c>j", "<Cmd>MDListItemBelow<CR>", { buffer = bufnr, desc = "markdown: add item below" })
	map("n", "<c-x>", "<cmd>MDTaskToggle<CR>", { buffer = bufnr, desc = "markdown: toggle checkbox" })
	map("x", "<c-x>", ":MDTaskToggle<CR>", { buffer = bufnr, desc = "markdown: toggle checkbox" })
	map("i", "<c-i>", require("helpers").toggle_emphasis("i"), { buffer = bufnr, desc = "markdown: toggle italic" })
	map("i", "<c-b>", require("helpers").toggle_emphasis("b"), { buffer = bufnr, desc = "markdown: toggle bold" })
	map("n", "<leader>p", "<cmd>MarkdownPreviewToggle<CR>", { buffer = bufnr, desc = "markdown: toggle preview" })
end
