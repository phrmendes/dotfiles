local setup, which_key = pcall(require, "which-key")
if not setup then
	return
end

local normal_opts = {
	mode = "n",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local normal_mappings = {
	d = {
		name = "+debugger",
		G = {
			name = "+go",
			["t"] = { "<cmd>lua require('dap-go').debug_test()<cr>", "Debug test" },
			["l"] = { "<cmd>lua require('dap-go').debug_latest_test()<cr>", "Debug latest test" },
		},
	},
}

which_key.register(normal_mappings, normal_opts)
