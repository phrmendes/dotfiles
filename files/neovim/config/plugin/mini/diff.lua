safely("event:BufReadPost", function()
  require("mini.diff").setup({
    view = { style = "sign" },
    signs = { add = "█", change = "▒", delete = "" },
  })
end)

safely("later", function()
  vim.keymap.set("n", "<leader>gd", function() MiniDiff.toggle_overlay(0) end, { desc = "Diff (file)" })
end)
