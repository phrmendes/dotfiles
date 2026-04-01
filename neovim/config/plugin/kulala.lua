safely("later", function()
  local kulala = require("kulala")
  kulala.setup({
    ui = {
      formatter = true,
      icons = { inlay = { done = "", error = "󰅚", loading = "" } },
      split_direction = "horizontal",
    },
    kulala_keymaps = {
      ["show headers"] = { "H", function() require("kulala.ui").show_headers() end },
    },
  })

  vim.keymap.set("n", "<leader>ks", kulala.scratchpad, { desc = "Scratchpad" })
end)

safely("event:FileType~*kulala_ui", function() vim.opt_local.buflisted = false end)

safely("filetype:http", function()
  local kulala = require("kulala")

  vim.keymap.set("n", "<leader>ka", kulala.run_all, { desc = "Send all" })
  vim.keymap.set("n", "<leader>ki", kulala.inspect, { desc = "Inspect" })
  vim.keymap.set("n", "<leader>kq", kulala.close, { desc = "Close" })
  vim.keymap.set("n", "<leader>kr", kulala.replay, { desc = "Replay" })
  vim.keymap.set({ "n", "x" }, "<leader>kk", kulala.run, { desc = "Send" })
  vim.keymap.set("n", "<leader>kc", kulala.copy, { desc = "Copy as curl command" })
  vim.keymap.set("n", "<leader>kf", kulala.from_curl, { desc = "Paste curl from clipboard" })
  vim.keymap.set("n", "<leader>kS", kulala.show_stats, { desc = "Statistics" })
end)
