local home = vim.env.HOME
local map = vim.keymap.set

require("chatgpt").setup({
	api_key_cmd = "gpg --decrypt " .. home .. "/.openai_api_key.gpg",
})

require("which-key").register({
	mode = { "n", "v" },
	["<leader>i"] = { name = "IA" },
})

map({ "n", "x" }, "<leader>iS", "<cmd>ChatGPTRun summarize<cr>", { desc = "Summarize" })
map({ "n", "x" }, "<leader>ia", "<cmd>ChatGPTRun add_tests<cr>", { desc = "Add tests" })
map({ "n", "x" }, "<leader>ic", "<cmd>ChatGPT<cr>", { desc = "ChatGPT" })
map({ "n", "x" }, "<leader>id", "<cmd>ChatGPTRun docstring<cr>", { desc = "Docstring" })
map({ "n", "x" }, "<leader>ie", "<cmd>ChatGPTEditWithInstruction<cr>", { desc = "Edit with instruction" })
map({ "n", "x" }, "<leader>if", "<cmd>ChatGPTRun fix_bugs<cr>", { desc = "Fix bugs" })
map({ "n", "x" }, "<leader>ig", "<cmd>ChatGPTRun grammar_correction<cr>", { desc = "Grammar correction" })
map({ "n", "x" }, "<leader>ik", "<cmd>ChatGPTRun keywords<cr>", { desc = "Keywords" })
map({ "n", "x" }, "<leader>il", "<cmd>ChatGPTRun code_readability_analysis<cr>", { desc = "Code readability analysis" })
map({ "n", "x" }, "<leader>io", "<cmd>ChatGPTRun optimize_code<cr>", { desc = "Optimize code" })
map({ "n", "x" }, "<leader>it", "<cmd>ChatGPTRun translate<cr>", { desc = "Translate" })
map({ "n", "x" }, "<leader>ix", "<cmd>ChatGPTRun explain_code<cr>", { desc = "Explain code" })
