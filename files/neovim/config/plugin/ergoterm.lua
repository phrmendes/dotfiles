safely("later", function()
  local ergoterm = require("ergoterm")

  ergoterm.setup({
    picker = { picker = "vim-ui-select" },
    terminal_defaults = {
      layout = "float",
      auto_scroll = true,
      cleanup_on_success = false,
      cleanup_on_failure = false,
      sticky = true,
      float_opts = {
        border = "rounded",
      },
    },
  })

  local shell = ergoterm:new({
    layout = "float",
    auto_list = false,
    bang_target = false,
    sticky = true,
    float_opts = { border = "rounded", width = 150, height = 30 },
    on_open = function(term)
      vim.keymap.set("n", "q", function() term:close() end, { buffer = 0, desc = "Close terminal" })
    end,
  })

  vim.keymap.set({ "n", "t" }, "<c-t>", function() shell:toggle() end, { desc = "Terminal" })
end)
