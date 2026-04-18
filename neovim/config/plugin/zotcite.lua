safely("filetype:markdown", function()
  require("zotcite").setup({ pdf_extractor = "pdfnotes2.py" })
  require("zotcite.seek").refs = require("helpers").zotcite_refs

  vim.keymap.set("n", "<leader>z", "", { buffer = true, desc = "+zotcite" })
end)
