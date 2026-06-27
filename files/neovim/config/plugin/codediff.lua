safely("now", function()
  require("codediff").setup({
    keymaps = {
      view = {
        toggle_explorer = "<leader>ge",
        focus_explorer = "<leader>gE",
      },
    },
  })

  vim.keymap.set("n", "<leader>gD", "<cmd>CodeDiff<cr>", { desc = "Diff (explorer)" })
end)
