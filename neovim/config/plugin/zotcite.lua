safely("filetype:markdown", function()
  require("zotcite").setup({ pdf_extractor = "pdfnotes2.py" })
  require("zotcite.seek").refs = require("helpers").zotcite_refs

  vim.keymap.set("i", "<c-b>", "<Plug>ZCite", { desc = "zotcite: insert citation" })
  vim.keymap.set("n", "<leader>zo", "<Plug>ZOpenAttachment", { desc = "zotcite: open attachment" })
  vim.keymap.set("n", "<leader>zi", "<Plug>ZCitationInfo", { desc = "zotcite: reference info" })
  vim.keymap.set("n", "<leader>za", "<Plug>ZCitationCompleteInfo", { desc = "zotcite: all reference fields" })
  vim.keymap.set("n", "<leader>zb", "<Plug>ZExtractAbstract", { desc = "zotcite: insert abstract" })
  vim.keymap.set("n", "<leader>zv", "<Plug>ZViewDocument", { desc = "zotcite: view document" })
end)
