local command = vim.api.nvim_create_user_command

command("Scratch", function()
	local buf = vim.api.nvim_get_current_buf()

	vim.cmd("bel 10new")

	for name, value in pairs({
		filetype = "scratch",
		buftype = "nofile",
		bufhidden = "hide",
		swapfile = false,
		modifiable = true,
	}) do
		vim.api.nvim_set_option_value(name, value, { buf = buf })
	end
end, { desc = "Open a scratch buffer", nargs = 0 })

command("Sessions", function()
	require("mini.sessions").select()
end, { desc = "Select session" })
