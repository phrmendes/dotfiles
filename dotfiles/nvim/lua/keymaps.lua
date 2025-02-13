local M = {}

M.mini = {
	files = function(event)
		local opts = { noremap = true, buffer = event.data.buf_id }

		vim.keymap.set("n", ".", require("utils").mini.files.toggle_dotfiles, opts)
		vim.keymap.set("n", "go", require("utils").mini.files.open_files, opts)
		vim.keymap.set("n", "<leader>.", require("utils").mini.files.set_cwd, opts)
		vim.keymap.set("n", "<leader>-", require("utils").mini.files.map_split("horizontal", true), opts)
		vim.keymap.set("n", "<leader>\\", require("utils").mini.files.map_split("vertical", true), opts)
	end,
}

M.ltex = function(client, bufnr)
	local opts = { buffer = bufnr }

	opts.desc = "Add word to dictionary"
	vim.keymap.set({ "n", "x" }, "zg", function()
		local word = vim.fn.expand("<cword>")

		local words = require("utils").add_word_to_dictionary(vim.g.ltex_language, word)

		local settings = client.config.settings

		if not settings then return end

		settings.ltex.dictionary[vim.g.ltex_language] = words

		client.notify("workspace/didChangeConfiguration", { settings = settings })
	end, opts)
end

return M
