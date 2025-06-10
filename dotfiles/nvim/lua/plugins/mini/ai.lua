MiniDeps.later(function()
	local ai = require("mini.ai")
	local extra = require("mini.extra")

	ai.setup({
		n_lines = 500,
		custom_textobjects = {
			B = extra.gen_ai_spec.buffer(),
			D = extra.gen_ai_spec.diagnostic(),
			I = extra.gen_ai_spec.indent(),
			L = extra.gen_ai_spec.line(),
			N = extra.gen_ai_spec.number(),
			o = ai.gen_spec.treesitter({
				a = { "@block.outer", "@conditional.outer", "@loop.outer" },
				i = { "@block.inner", "@conditional.inner", "@loop.inner" },
			}),
			f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
			c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
			t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
			u = ai.gen_spec.function_call(),
		},
	})
end)
