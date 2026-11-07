-- keep code fences and link markup visible
vim.opt_local.conceallevel = 0
vim.opt_local.concealcursor = ""

vim.b.minisurround_config = {
  custom_surroundings = {
    L = {
      input = { "%[().-()%]%(.-%)" },
      output = function()
        local link = require("mini.surround").user_input("Link: ")
        return { left = "[", right = "](" .. link .. ")" }
      end,
    },
  },
}
