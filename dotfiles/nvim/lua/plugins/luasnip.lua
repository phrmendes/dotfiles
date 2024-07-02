local from_vscode = require("luasnip.loaders.from_vscode")
local luasnip = require("luasnip")

luasnip.config.setup({
	enable_autosnippets = true,
	history = true,
	region_check_events = "InsertEnter",
	delete_check_events = "TextChanged,InsertLeave",
})

require("luasnip-latex-snippets").setup({
	use_treesitter = true,
	allow_on_markdown = true,
})

from_vscode.lazy_load()
from_vscode.lazy_load({ paths = { vim.env.HOME .. "/.config/nvim/snippets" } })

luasnip.filetype_extend("jinja", { "html" })
luasnip.filetype_extend("template", { "html" })
luasnip.filetype_extend("markdown", { "latex" })
luasnip.filetype_extend("quarto", { "markdown" })
