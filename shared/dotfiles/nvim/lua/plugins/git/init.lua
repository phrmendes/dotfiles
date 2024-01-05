local utils = require("utils")

utils.section({
	mode = { "n", "v" },
	key = "<leader>g",
	name = "git",
})

utils.section({
	mode = { "n", "v" },
	key = "<leader>gb",
	name = "buffer",
})

utils.section({
	mode = { "n", "v" },
	key = "<leader>gh",
	name = "hunk",
})

utils.section({
	mode = { "n", "v" },
	key = "<leader>gc",
	name = "commits",
})

require("plugins.git.gitsigns")
require("plugins.git.lazygit")

if vim.fn.has("mac") == 0 then
	require("plugins.git.octo")
end
