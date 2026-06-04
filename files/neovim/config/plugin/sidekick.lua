safely("now", function()
  local cli = require("sidekick.cli")

  require("sidekick").setup({
    nes = { enabled = false },
    cli = {
      mux = { backend = "tmux", enabled = true },
      win = {
        keys = {
          nav_left = false,
          nav_down = false,
          nav_up = false,
          nav_right = false,
        },
      },
    },
  })

  vim.keymap.set("n", "<leader>at", cli.toggle, { desc = "Toggle coding agent" })
  vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", cli.toggle, { desc = "Toggle" })
  vim.keymap.set({ "n", "x" }, "<leader>aa", function() cli.send({ msg = "{this}" }) end, { desc = "Send this" })
  vim.keymap.set({ "n", "x" }, "<leader>ad", cli.close, { desc = "Detach" })
  vim.keymap.set({ "n", "x" }, "<leader>af", function() cli.send({ msg = "{file}" }) end, { desc = "Send file" })
  vim.keymap.set({ "n", "x" }, "<leader>as", cli.select, { desc = "Select CLI" })
end)
