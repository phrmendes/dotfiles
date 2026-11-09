safely("now", function()
  local cli = require("sidekick.cli")

  require("sidekick").setup({
    nes = { enabled = false },
    cli = {
      tools = { pi = { cmd = { "pi", "--continue" } } },
      prompts = {
        comments_all = function() return require("haunt.sidekick").get_locations() end,
        comments_buffer = function() return require("haunt.sidekick").get_locations({ current_buffer = true }) end,
      },
      win = {
        keys = {
          stopinsert = { "<c-]>", "stopinsert", mode = "t", desc = "enter normal mode" },
          hide_ctrl_q = { "<c-]>", "hide", mode = "n", desc = "hide the terminal window" },
          nav_left = false,
          nav_down = false,
          nav_up = false,
          nav_right = false,
        },
      },
    },
  })

  vim.keymap.set("n", "<leader>at", cli.toggle, { desc = "Toggle coding agent" })
  vim.keymap.set({ "n", "x" }, "<leader>aa", function() cli.send({ msg = "\n{this}" }) end, { desc = "Send this" })
  vim.keymap.set("n", "<leader>ad", cli.close, { desc = "Detach" })
  vim.keymap.set("n", "<leader>ap", cli.prompt, { desc = "Prompts" })
  vim.keymap.set({ "n", "x" }, "<leader>af", function() cli.send({ msg = "\n{file}" }) end, { desc = "Send file" })
  vim.keymap.set({ "n", "x" }, "<leader>as", cli.select, { desc = "Select CLI" })
  vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", cli.toggle, { desc = "Toggle" })
end)
