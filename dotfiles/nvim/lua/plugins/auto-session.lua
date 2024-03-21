require("auto-session").setup({
	auto_restore_enabled = false,
	auto_save_enabled = true,
	auto_session_create_enabled = true,
	auto_session_enable_last_session = false,
	auto_session_enabled = true,
	auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
	session_lens = {
		load_on_setup = true,
		theme_conf = { border = true },
		previewer = false,
	},
})
