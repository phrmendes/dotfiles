safely("later", function()
  local haunt = require("haunt")
  local api = require("haunt.api")

  haunt.setup({
    picker = "auto",
    virt_text_pos = "above",
    per_branch_bookmarks = true,
  })

  vim.keymap.set("n", "[a", api.prev, { desc = "Haunt: previous bookmark" })
  vim.keymap.set("n", "]a", api.next, { desc = "Haunt: next bookmark" })
  vim.keymap.set("n", "<leader>hc", api.clear_all, { desc = "Clear all annotations" })
  vim.keymap.set("n", "<leader>hd", api.delete, { desc = "Delete bookmark" })
  vim.keymap.set("n", "<leader>hh", api.annotate, { desc = "Annotate" })
  vim.keymap.set("n", "<leader>hl", require("haunt.picker").show, { desc = "List bookmarks" })
  vim.keymap.set("n", "<leader>hq", api.to_quickfix, { desc = "Send buffer to quickfix" })
  vim.keymap.set("n", "<leader>ht", api.toggle_annotation, { desc = "Toggle annotation" })
  vim.keymap.set("n", "<leader>hT", api.toggle_all_lines, { desc = "Toggle all annotations" })
  vim.keymap.set("n", "<leader>hQ", function() api.to_quickfix({ current_buffer = false }) end, {
    desc = "Send all to quickfix",
  })
end)
