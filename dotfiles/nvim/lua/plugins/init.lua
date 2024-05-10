require("plugins.better-escape")
require("plugins.colorizer")
require("plugins.colorscheme")
require("plugins.completion")
require("plugins.copilot")
require("plugins.dap")
require("plugins.dressing")
require("plugins.executor")
require("plugins.git")
require("plugins.ibl")
require("plugins.jupytext")
require("plugins.lsp")
require("plugins.mini")
require("plugins.neogen")
require("plugins.nvim-tree")
require("plugins.quarto")
require("plugins.slime")
require("plugins.smartyank")
require("plugins.snippets")
require("plugins.spectre")
require("plugins.telescope")
require("plugins.todo")
require("plugins.treesitter")
require("plugins.which-key")
require("plugins.zen")

if vim.fn.has("mac") == 0 then
	require("plugins.obsidian")
end

if not vim.g.neovide then
	require("plugins.image")
end
