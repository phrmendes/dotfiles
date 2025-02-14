return {
	on_attach = function(client, bufnr)
		require("commands").ltex(bufnr)
		require("keymaps.ltex").setup(client, bufnr)
	end,
	settings = {
		ltex = {
			language = "none",
			markdown = { nodes = { Link = "dummy" } },
			dictionary = {
				["en-US"] = require("utils").get_dictionary_words("en-US"),
				["pt-BR"] = require("utils").get_dictionary_words("pt-BR"),
			},
		},
	},
}
