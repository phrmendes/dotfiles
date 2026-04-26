safely("later", function()
  require("zotcite").setup({ pdf_extractor = "pdfnotes2.py" })
  require("zotcite.seek").refs = require("helpers").zotcite_refs

  vim.keymap.set("n", "<leader>z", "", { desc = "+zotcite" })
  vim.keymap.set("i", "<c-x><c-b>", "<Plug>ZCite", { desc = "Insert citation" })
  vim.keymap.set("n", "<leader>zI", "<Plug>ZCitationCompleteInfo", { desc = "Show complete citation info" })
  vim.keymap.set("n", "<leader>za", "<Plug>ZExtractAbstract", { desc = "Extract abstract" })
  vim.keymap.set("n", "<leader>zi", "<Plug>ZCitationInfo", { desc = "Show citation info" })
  vim.keymap.set("n", "<leader>zo", "<Plug>ZOpenAttachment", { desc = "Open attachment" })
  vim.keymap.set("n", "<leader>zv", "<Plug>ZViewDocument", { desc = "View document" })
end)
