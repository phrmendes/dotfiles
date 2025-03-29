local get_dictionary_words = require("utils").get_dictionary_words

return {
	on_attach = function(client, bufnr)
		vim.keymap.set({ "n", "x" }, "zg", function()
			local word = vim.fn.expand("<cword>")
			local settings = client.config.settings
			local language = settings.ltex.language

			if language == "none" then
				vim.notify("Ltex is disabled", vim.log.levels.ERROR)
				return
			end

			local words = require("utils").add_word_to_dictionary(language, word)

			settings.ltex.dictionary[language] = words

			client:notify("workspace/didChangeConfiguration", { settings = settings })

			vim.notify("Word added to dictionary [`" .. language .. "`]: " .. word)
		end, { desc = "Ltex: add word to dictionary", buffer = bufnr })

		vim.api.nvim_buf_create_user_command(bufnr, "Ltex", function()
			local index = vim.g.ltex_index or 0
			local settings = client.config.settings

			local messages = {
				{
					lang = "en-US",
					index = 1,
					msg = "Ltex language: `en-US`",
				},
				{
					lang = "pt-BR",
					index = 2,
					msg = "Ltex language: `pt-BR`",
				},
				{
					lang = "none",
					index = 3,
					msg = "Ltex is disabled",
				},
			}

			local new_index = (index % #messages) + 1 or 1

			local result = vim.tbl_filter(function(t) return t.index == new_index end, messages)[1]

			vim.notify(result.msg)

			settings.ltex.language = result.lang

			client:notify("workspace/didChangeConfiguration", { settings = settings })

			vim.g.ltex_index = new_index
		end, { desc = "Ltex: toggle language" })
	end,
	settings = {
		ltex = {
			language = "none",
			markdown = { nodes = { Link = "dummy" } },
			dictionary = {
				["en-US"] = get_dictionary_words("en-US"),
				["pt-BR"] = get_dictionary_words("pt-BR"),
			},
		},
	},
}
