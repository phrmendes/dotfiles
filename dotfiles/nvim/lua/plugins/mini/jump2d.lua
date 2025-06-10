MiniDeps.later(function()
	local jump2d = require("mini.jump2d")

	jump2d.setup({
		mappings = { start_jumping = "<leader>j" },
		spotter = jump2d.gen_spotter.pattern("[^%s%p]+"),
		view = { dim = true, n_steps_ahead = 2 },
	})
end)
