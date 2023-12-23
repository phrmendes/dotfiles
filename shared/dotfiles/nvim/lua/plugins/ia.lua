local home = vim.env.HOME
local map = require("utils").map
local section = require("utils").section

require("chatgpt").setup({
	api_key_cmd = "gpg --decrypt " .. home .. "/.openai_api_key.gpg",
})

section({
	mode = { "n", "v" },
	key = "<leader>i",
	name = "IA",
})

map({
	mode = { "n", "v" },
	key = "<leader>iS",
	command = "<cmd>ChatGPTRun summarize<cr>",
	desc = "Summarize",
})

map({
	mode = { "n", "v" },
	key = "<leader>ia",
	command = "<cmd>ChatGPTRun add_tests<cr>",
	desc = "Add tests",
})

map({
	key = "<leader>ic",
	command = "<cmd>ChatGPT<cr>",
	desc = "ChatGPT",
})

map({
	mode = { "n", "v" },
	key = "<leader>id",
	command = "<cmd>ChatGPTRun docstring<cr>",
	desc = "Docstring",
})

map({
	mode = { "n", "v" },
	key = "<leader>ie",
	command = "<cmd>ChatGPTEditWithInstruction<cr>",
	desc = "Edit with instruction",
})

map({
	mode = { "n", "v" },
	key = "<leader>if",
	command = "<cmd>ChatGPTRun fix_bugs<cr>",
	desc = "Fix bugs",
})

map({
	mode = { "n", "v" },
	key = "<leader>ig",
	command = "<cmd>ChatGPTRun grammar_correction<cr>",
	desc = "Grammar correction",
})

map({
	mode = { "n", "v" },
	key = "<leader>ik",
	command = "<cmd>ChatGPTRun keywords<cr>",
	desc = "Keywords",
})

map({
	mode = { "n", "v" },
	key = "<leader>il",
	command = "<cmd>ChatGPTRun code_readability_analysis<cr>",
	desc = "Code readability analysis",
})

map({
	mode = { "n", "v" },
	key = "<leader>io",
	command = "<cmd>ChatGPTRun optimize_code<cr>",
	desc = "Optimize code",
})

map({
	mode = { "n", "v" },
	key = "<leader>it",
	command = "<cmd>ChatGPTRun translate<cr>",
	desc = "Translate",
})

map({
	mode = { "n", "v" },
	key = "<leader>ix",
	command = "<cmd>ChatGPTRun explain_code<cr>",
	desc = "Explain code",
})
