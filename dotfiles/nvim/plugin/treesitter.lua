MiniDeps.now(function()
	MiniDeps.add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "main",
		depends = { "nvim-treesitter/nvim-treesitter-context", "nvim-treesitter/nvim-treesitter-textobjects" },
		hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
	})

	MiniDeps.add({
		source = "nvim-treesitter/nvim-treesitter-textobjects",
		checkout = "main",
		depends = { "nvim-treesitter/nvim-treesitter" },
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
		"go",
		"gotmpl",
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
		"fish",
	})

	require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })

	require("keymaps.treesitter")
end)
