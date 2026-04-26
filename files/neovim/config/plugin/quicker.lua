safely("later", function()
  local quicker = require("quicker")

  quicker.setup({
    keys = {
      {
        ">",
        function() quicker.expand({ before = 2, after = 2, add_to_existing = true }) end,
        desc = "Expand quickfix context",
      },
      {
        "<",
        quicker.collapse,
        desc = "Collapse quickfix context",
      },
    },
  })

  vim.keymap.set("n", "<leader>x", quicker.toggle, { desc = "Quickfix" })
end)
