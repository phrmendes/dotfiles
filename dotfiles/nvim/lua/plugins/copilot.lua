MiniDeps.later(function()
	MiniDeps.add({ source = "zbirenbaum/copilot.lua" })
	MiniDeps.add({
		source = "CopilotC-Nvim/CopilotChat.nvim",
		depends = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim" },
	})

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

	vim.keymap.set("n", "<leader>c", "<cmd>CopilotChatToggle<cr>", { desc = "Chat" })
	vim.keymap.set({ "n", "x" }, "<leader>c", "<cmd>CopilotChat<cr>", { desc = "Chat" })
end)
