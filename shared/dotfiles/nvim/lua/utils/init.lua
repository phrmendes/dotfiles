local M = {}

M.augroup = vim.api.nvim_create_augroup("UserGroup", { clear = true })
M.map = require("utils.keybindings").map
M.match_pattern = require("utils.string").match_pattern
M.normalize = require("utils.string").normalize
M.section = require("utils.keybindings").section
M.venv = require("utils.python").venv
M.add_language_server = require("utils.lsp").add_language_server
M.handlers = require("utils.lsp").handlers
M.on_attach = require("utils.lsp").on_attach

return M
