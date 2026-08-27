safely("now", function() require("mini.statuscolumn").setup() end)

local excluded_filetypes = { "NeogitStatus" }

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "WinEnter" }, {
  desc = "Disable statuscolumn in certain filetypes",
  callback = function(event)
    if vim.list_contains(excluded_filetypes, vim.bo[event.buf].filetype) then vim.wo[vim.api.nvim_get_current_win()].statuscolumn = "" end
  end,
})
