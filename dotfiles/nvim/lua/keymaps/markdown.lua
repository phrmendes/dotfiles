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

  vim.keymap.set("n", "<leader>p", "<cmd>LivePreview start<cr>", {
    buffer = bufnr,
    desc = "markdown: toggle preview",
  })
end
