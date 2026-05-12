safely("now", function()
  local cli = require("sidekick.cli")

  require("sidekick").setup({
    nes = { enabled = false },
    cli = {
      win = { layout = "float" },
      mux = { backend = "tmux", enabled = true },
      tools = { opencode = {} },
    },
  })

  vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", cli.toggle, { desc = "Toggle coding agent" })
  vim.keymap.set({ "n", "x" }, "<leader>aa", function() cli.send({ msg = "{this}" }) end, { desc = "Send this" })
  vim.keymap.set({ "n", "x" }, "<leader>ad", cli.close, { desc = "Detach" })
  vim.keymap.set({ "n", "x" }, "<leader>af", function() cli.send({ msg = "{file}" }) end, { desc = "Send file" })
  vim.keymap.set({ "n", "x" }, "<leader>as", cli.select, { desc = "Select CLI" })
end)
