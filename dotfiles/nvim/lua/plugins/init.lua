require("plugins.better-escape")
require("plugins.colorizer")
require("plugins.colorscheme")
require("plugins.completion")
require("plugins.debugprint")
require("plugins.dressing")
require("plugins.git")
require("plugins.lsp")
require("plugins.lualine")
require("plugins.mini")
require("plugins.neogen")
require("plugins.neotree")
require("plugins.slime")
require("plugins.smartyank")
require("plugins.snippets")
require("plugins.spectre")
require("plugins.telescope")
require("plugins.todo")
require("plugins.treesitter")
require("plugins.which-key")
require("plugins.writing")
require("plugins.zen")

if vim.fn.has("mac") == 0 then
	require("plugins.ia")
	require("plugins.obsidian")
end