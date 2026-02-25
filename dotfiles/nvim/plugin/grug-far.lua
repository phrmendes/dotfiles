safely("later", function()
  local grug_far = require("grug-far")

  grug_far.setup({ transient = true })

  vim.keymap.set("n", "<leader>G", grug_far.open, { desc = "grug-far" })
  vim.keymap.set("v", "<leader>G", grug_far.with_visual_selection, { desc = "grug-far" })
end)
