local add, later = MiniDeps.add, MiniDeps.later
local map = vim.keymap.set

later(function()
	add({ source = "zbirenbaum/copilot.lua" })
	add({ source = "CopilotC-Nvim/CopilotChat.nvim", depends = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" } })

	vim.g.copilot_filetypes = { ["copilot-chat"] = false }

	require("copilot").setup({
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = true,
			keymap = {
				accept = "<c-l>",
				next = "<c-right>",
				prev = "<c-left>",
				dismiss = "<c-e>",
			},
		},
		server = {
			type = "binary",
			custom_server_filepath = require("nix.copilot"),
		},
	})

	require("CopilotChat").setup({
		chat_autocomplete = true,
		question_header = "# User ",
		answer_header = "# Copilot ",
		error_header = "# Error ",
		separator = "───",
		mappings = {
			submit_prompt = { normal = "<cr>", insert = "<c-s>" },
			reset = { normal = "<leader><bs>", insert = "<c-r>" },
		},
		prompts = {
			Concise = "Rewrite the following text to make it more concise:\n",
			Documentation = "Provide documentation for the following code:\n",
			Spelling = "Correct and improve any grammar or spelling errors in the following text:\n",
			Summarize = "Summarize the following text:\n",
		},
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		desc = "Options for copilot filetypes",
		group = vim.api.nvim_create_augroup("UserCopilotFileType", { clear = true }),
		pattern = "copilot-*",
		callback = function()
			vim.opt_local.relativenumber = false
			vim.opt_local.number = false
		end,
	})

	map("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Chat" })
	map({ "n", "x" }, "<leader>cc", "<cmd>CopilotChat<cr>", { desc = "Chat" })
end)
