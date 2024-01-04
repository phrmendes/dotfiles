local M = {}

M.section = function(args)
	local opts = {
		buffer = args.buffer or nil,
		key = args.key,
		mode = args.mode or "n",
		name = args.name,
	}

	require("which-key").register({
		mode = opts.mode,
		buffer = opts.buffer,
		[opts.key] = { name = opts.name },
	})
end

M.map = function(args, user_opts)
	local opts = {
		mode = args.mode or "n",
		key = args.key,
		command = args.command,
		keymap_opts = {
			desc = args.desc,
			buffer = args.buffer or nil,
		},
	}

	if user_opts then
		opts.keymap_opts = vim.tbl_extend("force", opts.keymap_opts, user_opts)
	end

	vim.keymap.set(opts.mode, opts.key, opts.command, opts.keymap_opts)
end

return M
