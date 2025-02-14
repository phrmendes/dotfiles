return {
	setup = function(client, bufnr)
		local opts = { buffer = bufnr }

		opts.desc = "Add word to dictionary"
		vim.keymap.set({ "n", "x" }, "zg", function()
			local word = vim.fn.expand("<cword>")

			local words = require("utils").add_word_to_dictionary(vim.g.ltex_language, word)

			local settings = client.config.settings

			if not settings then return end

			settings.ltex.dictionary[vim.g.ltex_language] = words

			client.notify("workspace/didChangeConfiguration", { settings = settings })
		end, opts)
	end,
}
