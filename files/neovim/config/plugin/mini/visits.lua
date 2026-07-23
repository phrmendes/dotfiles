safely("later", function()
  require("mini.visits").setup()

  local sort_recent = MiniVisits.gen_sort.default({ recency_weight = 1 })
  local iterate_opts = { sort = sort_recent, wrap = true }
  local pin_opts = vim.tbl_extend("force", iterate_opts, { filter = "pin" })

  vim.keymap.set("n", "[v", function() MiniVisits.iterate_paths("backward", nil, iterate_opts) end, { desc = "Previous visit (MRU)" })
  vim.keymap.set("n", "]v", function() MiniVisits.iterate_paths("forward", nil, iterate_opts) end, { desc = "Next visit (MRU)" })
  vim.keymap.set("n", "[V", function() MiniVisits.iterate_paths("first", nil, iterate_opts) end, { desc = "Most recent visit" })
  vim.keymap.set("n", "]V", function() MiniVisits.iterate_paths("last", nil, iterate_opts) end, { desc = "Oldest visit" })
  vim.keymap.set("n", "[[", function() MiniVisits.iterate_paths("backward", nil, pin_opts) end, { desc = "Previous pin" })
  vim.keymap.set("n", "]]", function() MiniVisits.iterate_paths("forward", nil, pin_opts) end, { desc = "Next pin" })

  vim.keymap.set("n", "<c-c>l", function() MiniExtra.pickers.visit_paths({ filter = "pin" }) end, { desc = "Pins" })
  vim.keymap.set("n", "<c-c>p", function() MiniVisits.add_label("pin") end, { desc = "Pin file" })
  vim.keymap.set("n", "<c-c>u", function() MiniVisits.remove_label("pin") end, { desc = "Unpin file" })

  vim.keymap.set("n", "<leader>V", function() MiniExtra.pickers.visit_paths({ cwd = "", sort = sort_recent }) end, { desc = "Visits (all)" })
  vim.keymap.set("n", "<leader>v", function() MiniExtra.pickers.visit_paths({ sort = sort_recent }) end, { desc = "Visits (cwd)" })
end)
