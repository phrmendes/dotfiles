safely("later", function()
  local et = require("ergoterm")

  et.setup({
    picker = {
      picker = "vim-ui-select",
      select_actions = {
        default = {
          fn = function(term)
            if term then term.default_action(term) end
          end,
          desc = "Default action",
        },
      },
    },
    terminal_defaults = {
      layout = "float",
      shell = "nu",
      auto_scroll = true,
      cleanup_on_success = false,
      sticky = true,
      float_winblend = 0,
      float_opts = { border = "rounded", width = 150, height = 30 },
    },
  })

  vim.keymap.set({ "n", "t" }, "<c-\\><c-\\>", function() (et.get_target_for_bang() or et:new()):toggle() end, { desc = "Terminal" })
  vim.keymap.set({ "n", "t" }, "<c-\\>n", "<cmd>TermNew<cr>", { desc = "New terminal" })
  vim.keymap.set({ "n", "t" }, "<c-\\>]", function() require("helpers").ergoterm.cycle(1) end, { desc = "Next terminal" })
  vim.keymap.set({ "n", "t" }, "<c-\\>[", function() require("helpers").ergoterm.cycle(-1) end, { desc = "Previous terminal" })
  vim.keymap.set({ "n", "t" }, "<c-\\>s", "<cmd>TermSelect<cr>", { desc = "Select terminal" })
  vim.keymap.set({ "n", "t" }, "<c-\\>x", function() et.cleanup_all({ force = true }) end, { desc = "Delete all terminals" })
  vim.keymap.set("n", "<c-\\>r", ":TermUpdate! name=", { desc = "Rename terminal" })
  vim.keymap.set("t", "<c-\\>r", "<c-\\><c-n>:TermUpdate! name=", { desc = "Rename terminal" })
end)
