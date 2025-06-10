local plugins_path = vim.fs.joinpath(vim.fn.stdpath("data"), "site")
local mini_path = vim.fs.joinpath(plugins_path, "/pack", "deps", "start", "mini.nvim")
local nix_path = vim.fn.stdpath("data") .. "/nix"
local dev_plugins_paths = require("helpers").get_subdirectories(vim.env.HOME .. "/Projects/vim_plugins")
local paths = vim.iter({ mini_path, nix_path, dev_plugins_paths }):flatten():totable()

if not vim.uv.fs_stat(mini_path) then
	local mini_repo = "https://github.com/echasnovski/mini.nvim"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", mini_repo, mini_path })

	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to clone `mini.nvim`", vim.log.levels.ERROR)
		vim.notify(out, vim.log.levels.WARN)
		os.exit(1)
	end
end

require("mini.deps").setup({ path = { package = plugins_path } })

vim.iter(paths):each(function(path) vim.opt.rtp:prepend(path) end)

require("options")
require("autocmds")
require("keymaps")
require("plugins")
