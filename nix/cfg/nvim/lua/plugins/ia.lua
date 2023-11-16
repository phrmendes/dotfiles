local home = os.getenv("HOME")
local chatgpt = require("chatgpt")
local map = vim.keymap.set

chatgpt.setup({
	api_key_cmd = "gpg --decrypt " .. home .. "/.openai-token.gpg",
})

map("n", "<Leader>is", "<cmd>Copilot panel<cr>", { desc = "Copilot: sugestions" })
map({ "n", "x" }, "<Leader>iS", "<cmd>ChatGPTRun summarize<cr>", { desc = "Summarize" })
map({ "n", "x" }, "<Leader>ia", "<cmd>ChatGPTRun add_tests<cr>", { desc = "Add tests" })
map({ "n", "x" }, "<Leader>ic", "<cmd>ChatGPT<cr>", { desc = "ChatGPT" })
map({ "n", "x" }, "<Leader>id", "<cmd>ChatGPTRun docstring<cr>", { desc = "Docstring" })
map({ "n", "x" }, "<Leader>ie", "<cmd>ChatGPTEditWithInstruction<cr>", { desc = "Edit with instruction" })
map({ "n", "x" }, "<Leader>if", "<cmd>ChatGPTRun fix_bugs<cr>", { desc = "Fix bugs" })
map({ "n", "x" }, "<Leader>ig", "<cmd>ChatGPTRun grammar_correction<cr>", { desc = "Grammar correction" })
map({ "n", "x" }, "<Leader>ik", "<cmd>ChatGPTRun keywords<cr>", { desc = "Keywords" })
map({ "n", "x" }, "<Leader>il", "<cmd>ChatGPTRun code_readability_analysis<cr>", { desc = "Code readability analysis" })
map({ "n", "x" }, "<Leader>io", "<cmd>ChatGPTRun optimize_code<cr>", { desc = "Optimize code" })
map({ "n", "x" }, "<Leader>it", "<cmd>ChatGPTRun translate<cr>", { desc = "Translate" })
map({ "n", "x" }, "<Leader>ix", "<cmd>ChatGPTRun explain_code<cr>", { desc = "Explain code" })
