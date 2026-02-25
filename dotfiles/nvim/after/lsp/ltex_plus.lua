local helpers = require("helpers")

return {
  on_attach = function(client, bufnr)
    vim.keymap.set({ "n", "x" }, "zg", function()
      local word = vim.fn.expand("<cword>")
      local settings = client.config.settings
      local language = settings.ltex.language

      if language == "none" then return vim.notify("No language enabled", vim.log.levels.ERROR, { title = "Ltex" }) end

      local words = helpers.add_word_to_dictionary(language, word)
      settings.ltex.dictionary[language] = words
      client:notify("workspace/didChangeConfiguration", { settings = settings })
      vim.notify("Word added to dictionary `" .. language .. "`: " .. word, vim.log.levels.INFO, { title = "Ltex" })
    end, { desc = "Ltex: add word to dictionary", buffer = bufnr })

    vim.api.nvim_buf_create_user_command(bufnr, "Ltex", function()
      local languages = { "en-US", "pt-BR", "none" }
      local index = vim.g.ltex_index or 0
      local new_index = (index % #languages) + 1
      local lang = languages[new_index]

      client.config.settings.ltex.language = lang
      client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      vim.notify("Language: `" .. lang .. "`", vim.log.levels.INFO, { title = "Ltex" })
      vim.g.ltex_index = new_index
    end, { desc = "Ltex: toggle language" })
  end,
  settings = {
    ltex = {
      language = "none",
      markdown = { nodes = { Link = "dummy" } },
      dictionary = {
        ["en-US"] = helpers.get_dictionary_words("en-US"),
        ["pt-BR"] = helpers.get_dictionary_words("pt-BR"),
      },
    },
  },
}
