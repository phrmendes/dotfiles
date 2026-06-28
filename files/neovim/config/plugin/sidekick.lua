package.loaded["sidekick.cli.picker.mini.pick"] = require("helpers").sidekick

safely("now", function()
  local cli = require("sidekick.cli")

  require("sidekick").setup({
    nes = { enabled = false },
    cli = {
      picker = "mini.pick",
      mux = { backend = "tmux", enabled = true },
      prompts = {
        dev = "Load /skill:dev. Instructions: ",
        plan = "Load /skill:plan. Instructions: ",
        guide = "Load /skill:guide. Instructions: ",
        research = "Load /skill:research. Instructions: ",
        review = "Load /skill:review. Instructions: ",
      },
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
  vim.keymap.set({ "n", "x" }, "<leader>aa", function() cli.send({ msg = "{this}" }) end, { desc = "Send this" })
  vim.keymap.set({ "n", "x" }, "<leader>ap", cli.prompt, { desc = "Select prompt" })
  vim.keymap.set({ "n", "x" }, "<leader>ad", cli.close, { desc = "Detach" })
  vim.keymap.set({ "n", "x" }, "<leader>af", function() cli.send({ msg = "{file}" }) end, { desc = "Send file" })
  vim.keymap.set({ "n", "x" }, "<leader>as", cli.select, { desc = "Select CLI" })
  vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", cli.toggle, { desc = "Toggle" })
end)
