local starter = require("mini.starter")

starter.setup({
	evaluate_single = true,
	items = {
		starter.sections.sessions(5, true),
		starter.sections.recent_files(5, true),
		starter.sections.recent_files(5, false),
		starter.sections.builtin_actions(),
	},
	content_hooks = {
		starter.gen_hook.adding_bullet(),
		starter.gen_hook.indexing("all", { "Builtin actions" }),
		starter.gen_hook.aligning("center", "center"),
	},
})
