local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazy_path) then
	local lazy_repo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazy_repo, lazy_path })

	if vim.v.shell_error ~= 0 then
		vim.notify("Failed to clone `lazy.nvim`", vim.log.levels.ERROR)
		vim.notify(out, vim.log.levels.WARN)
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
	spec = { { import = "plugins" } },
	checker = { enabled = true },
	ui = { border = "rounded" },
	rocks = { enabled = false },
	dev = { path = vim.env.HOME .. "/Projects/vim_plugins", fallback = true },
	performance = {
		rtp = {
			paths = { vim.fn.stdpath("data") .. "/nix" },
			disabled_plugins = {
				"2html_plugin",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"matchit",
				"netrw",
				"netrwFileHandlers",
				"netrwPlugin",
				"netrwSettings",
				"rrhelper",
				"spellfile_plugin",
				"tar",
				"tarPlugin",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
			},
		},
	},
})
