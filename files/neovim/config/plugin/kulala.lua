safely("later", function()
  local kulala = require("kulala")

  kulala.setup({
    default_env = "default",
    environment_scope = "b",
  })

  vim.keymap.set("n", "<leader>ko", kulala.scratchpad, { desc = "Open scratchpad" })
end)
