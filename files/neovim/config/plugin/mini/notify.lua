safely("now", function()
  require("mini.notify").setup({
    window = { config = { border = vim.g.border } },
    content = {
      sort = function(array)
        local to_filter = { "Diagnosing", "Processing files", "file to analyze", "ltex" }
        return MiniNotify.default_sort(vim.iter(to_filter):fold(array, function(tbl, filter)
          return vim.iter(tbl):filter(function(n) return not string.find(n.msg, filter) end):totable()
        end))
      end,
    },
  })

  vim.notify = MiniNotify.make_notify()
end)

safely("later", function()
  vim.keymap.set("n", "<leader><del>", MiniNotify.clear, { desc = "Clear notifications" })
  vim.keymap.set("n", "<leader>N", MiniNotify.show_history, { desc = "Notifications" })
end)
