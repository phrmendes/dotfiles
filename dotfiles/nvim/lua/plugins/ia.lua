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
	cmd = "<CMD>ChatGPTRun summarize<CR>",
	desc = "Summarize",
})

map({
	mode = { "n", "v" },
	key = "<leader>ia",
	cmd = "<CMD>ChatGPTRun add_tests<CR>",
	desc = "Add tests",
})

map({
	key = "<leader>ic",
	cmd = "<CMD>ChatGPT<CR>",
	desc = "ChatGPT",
})

map({
	mode = { "n", "v" },
	key = "<leader>id",
	cmd = "<CMD>ChatGPTRun docstring<CR>",
	desc = "Docstring",
})

map({
	mode = { "n", "v" },
	key = "<leader>ie",
	cmd = "<CMD>ChatGPTEditWithInstruction<CR>",
	desc = "Edit with instruction",
})

map({
	mode = { "n", "v" },
	key = "<leader>if",
	cmd = "<CMD>ChatGPTRun fix_bugs<CR>",
	desc = "Fix bugs",
})

map({
	mode = { "n", "v" },
	key = "<leader>ig",
	cmd = "<CMD>ChatGPTRun grammar_correction<CR>",
	desc = "Grammar correction",
})

map({
	mode = { "n", "v" },
	key = "<leader>ik",
	cmd = "<CMD>ChatGPTRun keywords<CR>",
	desc = "Keywords",
})

map({
	mode = { "n", "v" },
	key = "<leader>il",
	cmd = "<CMD>ChatGPTRun code_readability_analysis<CR>",
	desc = "Code readability analysis",
})

map({
	mode = { "n", "v" },
	key = "<leader>io",
	cmd = "<CMD>ChatGPTRun optimize_code<CR>",
	desc = "Optimize code",
})

map({
	mode = { "n", "v" },
	key = "<leader>it",
	cmd = "<CMD>ChatGPTRun translate<CR>",
	desc = "Translate",
})

map({
	mode = { "n", "v" },
	key = "<leader>ix",
	cmd = "<CMD>ChatGPTRun explain_code<CR>",
	desc = "Explain code",
})
