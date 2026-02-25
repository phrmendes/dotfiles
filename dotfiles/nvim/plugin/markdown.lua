safely("filetype:markdown", function()
  require("markdown").setup({
    on_attach = function()
      vim.keymap.set("n", "<c-x>", "<cmd>MDTaskToggle<cr>", { desc = "markdown: toggle checkbox" })
      vim.keymap.set("x", "<c-x>", ":MDTaskToggle<cr>", { desc = "markdown: toggle checkbox" })
      vim.keymap.set({ "n", "i" }, "<c-c>k", "<cmd>MDListItemAbove<cr>", { desc = "markdown: add item above" })
      vim.keymap.set({ "n", "i" }, "<c-c>j", "<cmd>MDListItemBelow<cr>", { desc = "markdown: add item below" })
      vim.keymap.set("n", "<leader>p", "<cmd>LivePreview start<cr>", { desc = "markdown: toggle preview" })
    end,
  })
end)
