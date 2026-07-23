safely("later", function()
  require("mini.surround").setup({
    mappings = {
      add = "gsa",
      delete = "gsd",
      find = "gsf",
      find_left = "gsF",
      highlight = "gsh",
      replace = "gsr",
      update_n_lines = "gsn",
      suffix_last = "l",
      suffix_next = "n",
    },
  })

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Disable surround in certain filetypes",
    pattern = "gitrebase",
    callback = function(event) vim.b[event.buf].minisurround_disable = true end,
  })
end)
