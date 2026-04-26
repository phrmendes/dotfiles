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
