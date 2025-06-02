local package_path = vim.fn.stdpath("data") .. "/site/"
local mini_path = package_path .. "pack/deps/start/mini.nvim"
local dev_path = vim.env.HOME .. "/Projects/vim_plugins"
local nix_path = vim.fn.stdpath("data") .. "/nix"

if not vim.uv.fs_stat(mini_path) then
	local mini_repo = "https://github.com/echasnovski/mini.nvim"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", mini_repo, mini_path })

	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to clone `mini.nvim`", vim.log.levels.ERROR)
		vim.notify(out, vim.log.levels.WARN)
		os.exit(1)
	end
end

require("mini.deps").setup({ path = { package = package_path } })

vim.iter({ mini_path, dev_path, nix_path }):each(function(path) vim.opt.rtp:prepend(path) end)

require("options")
require("autocmds")
require("keymaps")
require("plugins")
