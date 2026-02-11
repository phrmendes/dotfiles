return function(bufnr)
  vim.keymap.set("n", "<c-x>", "<cmd>MDTaskToggle<cr>", { buffer = bufnr, desc = "markdown: toggle checkbox" })
  vim.keymap.set("x", "<c-x>", ":MDTaskToggle<cr>", { buffer = bufnr, desc = "markdown: toggle checkbox" })

  vim.keymap.set({ "n", "i" }, "<c-c>k", "<cmd>MDListItemAbove<cr>", {
    buffer = bufnr,
    desc = "markdown: add item above",
  })
  vim.keymap.set({ "n", "i" }, "<c-c>j", "<cmd>MDListItemBelow<cr>", {
    buffer = bufnr,
    desc = "markdown: add item below",
  })

  vim.keymap.set("i", "<c-i>", require("helpers").toggle_emphasis("i"), {
    buffer = bufnr,
    desc = "markdown: toggle italic",
  })

  vim.keymap.set("i", "<c-b>", require("helpers").toggle_emphasis("b"), {
    buffer = bufnr,
    desc = "markdown: toggle bold",
  })

  vim.keymap.set("n", "<leader>p", "<cmd>LivePreview start<cr>", {
    buffer = bufnr,
    desc = "markdown: toggle preview",
  })
end
