now(function()
	vim.pack.add({
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main", name = "ts" },
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
		"https://github.com/nvim-treesitter/nvim-treesitter-context",
	})

	vim.g.no_plugin_maps = true

	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name, kind = ev.data.spec.name, ev.data.kind
			if name == "ts" and (kind == "install" or kind == "update") then vim.cmd("TSUpdate") end
		end,
	})

	require("nvim-treesitter").install({
		"astro",
		"bash",
		"bibtex",
		"caddy",
		"css",
		"csv",
		"cuda",
		"diff",
		"dockerfile",
		"dot",
		"eex",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"hcl",
		"heex",
		"helm",
		"html",
		"htmldjango",
		"http",
		"java",
		"javascript",
		"json",
		"just",
		"latex",
		"lua",
		"luadoc",
		"luap",
		"make",
		"markdown",
		"markdown_inline",
		"mermaid",
		"nginx",
		"nix",
		"python",
		"regex",
		"requirements",
		"sql",
		"ssh_config",
		"templ",
		"terraform",
		"todotxt",
		"toml",
		"typescript",
		"vim",
		"vimdoc",
		"yaml",
		"zsh",
	})

	require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })

	require("keymaps.treesitter")
end)
