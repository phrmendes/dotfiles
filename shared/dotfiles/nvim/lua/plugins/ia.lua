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
	cmd = "<cmd>ChatGPTRun summarize<cr>",
	desc = "Summarize",
})

map({
	mode = { "n", "v" },
	key = "<leader>ia",
	cmd = "<cmd>ChatGPTRun add_tests<cr>",
	desc = "Add tests",
})

map({
	key = "<leader>ic",
	cmd = "<cmd>ChatGPT<cr>",
	desc = "ChatGPT",
})

map({
	mode = { "n", "v" },
	key = "<leader>id",
	cmd = "<cmd>ChatGPTRun docstring<cr>",
	desc = "Docstring",
})

map({
	mode = { "n", "v" },
	key = "<leader>ie",
	cmd = "<cmd>ChatGPTEditWithInstruction<cr>",
	desc = "Edit with instruction",
})

map({
	mode = { "n", "v" },
	key = "<leader>if",
	cmd = "<cmd>ChatGPTRun fix_bugs<cr>",
	desc = "Fix bugs",
})

map({
	mode = { "n", "v" },
	key = "<leader>ig",
	cmd = "<cmd>ChatGPTRun grammar_correction<cr>",
	desc = "Grammar correction",
})

map({
	mode = { "n", "v" },
	key = "<leader>ik",
	cmd = "<cmd>ChatGPTRun keywords<cr>",
	desc = "Keywords",
})

map({
	mode = { "n", "v" },
	key = "<leader>il",
	cmd = "<cmd>ChatGPTRun code_readability_analysis<cr>",
	desc = "Code readability analysis",
})

map({
	mode = { "n", "v" },
	key = "<leader>io",
	cmd = "<cmd>ChatGPTRun optimize_code<cr>",
	desc = "Optimize code",
})

map({
	mode = { "n", "v" },
	key = "<leader>it",
	cmd = "<cmd>ChatGPTRun translate<cr>",
	desc = "Translate",
})

map({
	mode = { "n", "v" },
	key = "<leader>ix",
	cmd = "<cmd>ChatGPTRun explain_code<cr>",
	desc = "Explain code",
})
