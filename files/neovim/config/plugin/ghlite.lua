safely("later", function()
  require("ghlite").setup({
    comment_hunk = true,
    keymaps = {
      diff = {
        approve = "cA",
        request_changes = "cR",
      },
      pr = {
        approve = "cA",
        request_changes = "cR",
        merge = "cM",
        comment = "ca",
        diff = "cp",
      },
    },
  })

  vim.keymap.set("n", "<leader>gpc", "<cmd>GHLitePRCheckout<cr>", { desc = "Checkout" })
  vim.keymap.set("n", "<leader>gpd", "<cmd>GHLitePRDiff<cr>", { desc = "Diff" })
  vim.keymap.set("n", "<leader>gpl", "<cmd>GHLitePRLoadComments<cr>", { desc = "Load comments" })
  vim.keymap.set("n", "<leader>gpo", "<cmd>GHLitePROpenComment<cr>", { desc = "Open comment" })
  vim.keymap.set("n", "<leader>gps", "<cmd>GHLitePRSelect<cr>", { desc = "Select" })
  vim.keymap.set("n", "<leader>gpu", "<cmd>GHLitePRUpdateComment<cr>", { desc = "Update comment" })
  vim.keymap.set("n", "<leader>gpv", "<cmd>GHLitePRView<cr>", { desc = "View" })
  vim.keymap.set("n", "<leader>gpx", "<cmd>GHLitePRDeleteComment<cr>", { desc = "Delete comment" })
  vim.keymap.set({ "n", "x" }, "<leader>gpa", "<cmd>GHLitePRAddComment<cr>", { desc = "Add comment" })
end)
