local M = {}

M.augroup = vim.api.nvim_create_augroup("UserGroup", { clear = true })
M.add_language_server = require("utils.lsp").add_language_server
M.on_attach = require("utils.lsp").on_attach
M.handlers = require("utils.lsp").handlers
M.map = require("utils.keybindings").map
M.section = require("utils.keybindings").section
M.match_pattern = require("utils.string").match_pattern
M.normalize = require("utils.string").normalize
M.has_words_before = require("utils.string").has_words_before
M.metals = require("utils.lualine").metals
M.venv = require("utils.lualine").venv

return M
