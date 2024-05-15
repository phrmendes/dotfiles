require("mini.align").setup()
require("mini.bufremove").setup()
require("mini.clue").setup()
require("mini.cursorword").setup()
require("mini.fuzzy").setup()
require("mini.indentscope").setup()
require("mini.jump").setup()
require("mini.operators").setup()
require("mini.pairs").setup()
require("mini.sessions").setup()
require("mini.starter").setup()
require("mini.tabline").setup()
require("mini.trailspace").setup()

require("mini.diff").setup({ view = { style = "sign" } })
require("mini.jump2d").setup({ mappings = { start_jumping = "<leader>j" } })
require("mini.notify").setup({ lsp_progress = { enable = false } })
require("mini.splitjoin").setup({ mappings = { toggle = "T" } })
require("mini.statusline").setup({ set_vim_settings = false })

require("mini.ai").setup({
	n_lines = 500,
	custom_textobjects = {
		o = require("mini.ai").gen_spec.treesitter({
			a = { "@block.outer", "@conditional.outer", "@loop.outer" },
			i = { "@block.inner", "@conditional.inner", "@loop.inner" },
		}, {}),
		f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
		c = require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
	},
})

require("mini.bracketed").setup({
	diagnostic = { options = { float = false } },
	file = { suffix = "" },
	comment = { suffix = "" },
})

require("mini.comment").setup({
	options = {
		custom_commentstring = function()
			return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
		end,
	},
})

require("mini.files").setup({
	mappings = {
		close = "q",
		go_in = "l",
		go_in_plus = "<cr>",
		go_out = "h",
		go_out_plus = "<bs>",
		reset = "<del>",
		reveal_cwd = "@",
		show_help = "?",
		synchronize = "=",
		trim_left = "<",
		trim_right = ">",
	},
})

require("mini.move").setup({
	mappings = {
		down = "<S-j>",
		left = "<S-h>",
		right = "<S-l>",
		up = "<S-k>",
		line_down = "<S-j>",
		line_left = "<S-h>",
		line_right = "<S-l>",
		line_up = "<S-k>",
	},
})

require("mini.surround").setup({
	mappings = {
		add = "sa",
		find = "sf",
		find_left = "sF",
		highlight = "sh",
		replace = "sr",
		update_n_lines = "sn",
		suffix_last = "l",
		suffix_next = "n",
	},
})
