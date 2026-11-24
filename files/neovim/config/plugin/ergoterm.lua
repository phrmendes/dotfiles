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
      shell = vim.fn.executable("nu") == 1 and "nu" or "bash",
      auto_scroll = true,
      cleanup_on_success = false,
      sticky = true,
      float_winblend = 0,
      float_opts = { border = "rounded", width = 150, height = 30 },
    },
  })

  local leader = vim.g.terminalleader

  vim.keymap.set({ "n", "t" }, leader .. leader, function() (et.get_target_for_bang() or et:new()):toggle() end, { desc = "Terminal" })
  vim.keymap.set({ "n", "t" }, leader .. "n", "<cmd>TermNew<cr>", { desc = "New terminal" })
  vim.keymap.set({ "n", "t" }, leader .. "]", function() require("helpers").ergoterm.cycle(1) end, { desc = "Next terminal" })
  vim.keymap.set({ "n", "t" }, leader .. "[", function() require("helpers").ergoterm.cycle(-1) end, { desc = "Previous terminal" })
  vim.keymap.set({ "n", "t" }, leader .. "s", "<cmd>TermSelect<cr>", { desc = "Select terminal" })
  vim.keymap.set({ "n", "t" }, leader .. "x", function() et.cleanup_all({ force = true }) end, { desc = "Delete all terminals" })
  vim.keymap.set("n", leader .. "r", ":TermUpdate! name=", { desc = "Rename terminal" })
  vim.keymap.set("t", leader .. "r", "<c-\\><c-n>:TermUpdate! name=", { desc = "Rename terminal" })
end)
