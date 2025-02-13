local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<leader>p", "<cmd>MarkdownPreviewToggle<cr>", {
	desc = "Preview markdown file",
	buffer = bufnr,
})

vim.keymap.set({ "n", "i" }, "<c-c>j", "<cmd>MDListItemBelow<cr>", {
	desc = "Markdown: add item below",
	buffer = bufnr,
})

vim.keymap.set({ "n", "i" }, "<c-c>k", "<cmd>MDListItemAbove<cr>", {
	desc = "Markdown: add item above",
	buffer = bufnr,
})

vim.keymap.set({ "n", "v" }, "<c-c>x", ":MDTaskToggle<cr>", {
	desc = "Markdown: toggle checkbox",
	buffer = bufnr,
})

vim.keymap.set("v", "<c-i>", require("utils").toggle_emphasis("i"), {
	desc = "Markdown: toggle italic",
	buffer = bufnr,
})

vim.keymap.set("v", "<c-b>", require("utils").toggle_emphasis("b"), {
	desc = "Markdown: toggle bold",
	buffer = bufnr,
})
