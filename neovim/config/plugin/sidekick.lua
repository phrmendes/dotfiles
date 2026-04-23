safely("now", function()
  require("sidekick").setup({
    nes = {
      diff = {
        inline = "words",
        show = "always",
      },
    },
    cli = {
      watch = true,
      win = {
        layout = "right",
      },
      tools = {
        pi = {},
        opencode = {},
      },
    },
  })

  vim.keymap.set({ "i", "n" }, "<tab>", function()
    if require("sidekick").nes_jump_or_apply() then return end
    if vim.lsp.inline_completion.get() then return end
    return "<tab>"
  end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

  vim.keymap.set({ "n", "t", "i", "x" }, "<c-.>", function() require("sidekick.cli").focus() end, { desc = "Focus" })
  vim.keymap.set("n", "<leader>aa", function() require("sidekick.cli").toggle() end, { desc = "Toggle CLI" })
  vim.keymap.set("n", "<leader>aS", function() require("sidekick.cli").select() end, { desc = "Select CLI" })
  vim.keymap.set("n", "<leader>ad", function() require("sidekick.cli").close() end, { desc = "Detach a CLI session" })
  vim.keymap.set({ "x", "n" }, "<leader>as", function() require("sidekick.cli").send({ msg = "{this}" }) end, { desc = "Send" })
  vim.keymap.set("n", "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, { desc = "Send file" })
  vim.keymap.set({ "n", "x" }, "<leader>ap", function() require("sidekick.cli").prompt() end, { desc = "Select prompt" })
end)
