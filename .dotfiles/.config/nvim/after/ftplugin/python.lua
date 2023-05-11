local setup, which_key = pcall(require, "which-key")
if not setup then
	return
end

local visual_opts = {
	mode = "v",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local normal_opts = {
	mode = "n",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = false,
}

local visual_mappings = {
	["p"] = { "<cmd>lua require('dap-python').debug_selection()<cr>", "DAP - Debug python region" },
}

local normal_mappings = {
	d = {
		name = "+debugger",
		P = {
			name = "+python",
			["c"] = { "<cmd>lua require('dap-python').test_class()<cr>", "Test class" },
			["m"] = { "<cmd>lua require('dap-python').test_method()<cr>", "Test method" },
		},
	},
}

which_key.register(visual_mappings, visual_opts)
which_key.register(normal_mappings, normal_opts)
