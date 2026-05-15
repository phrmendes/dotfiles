safely("now", function()
  local splits = require("smart-splits")

  splits.setup({
    cursor_follows_swapped_bufs = true,
    ignored_filetypes = { "sidekick_terminal" },
  })

  vim.keymap.set({ "n", "t" }, "<a-h>", splits.resize_left, { desc = "Resize left" })
  vim.keymap.set({ "n", "t" }, "<a-j>", splits.resize_down, { desc = "Resize down" })
  vim.keymap.set({ "n", "t" }, "<a-k>", splits.resize_up, { desc = "Resize up" })
  vim.keymap.set({ "n", "t" }, "<a-l>", splits.resize_right, { desc = "Resize right" })
  vim.keymap.set({ "n", "t" }, "<c-h>", splits.move_cursor_left, { desc = "Move to left split" })
  vim.keymap.set({ "n", "t" }, "<c-j>", splits.move_cursor_down, { desc = "Move to below split" })
  vim.keymap.set({ "n", "t" }, "<c-k>", splits.move_cursor_up, { desc = "Move to above split" })
  vim.keymap.set({ "n", "t" }, "<c-l>", splits.move_cursor_right, { desc = "Move to right split" })
end)
