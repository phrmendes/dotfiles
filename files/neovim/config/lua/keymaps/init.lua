vim.iter({ "gra", "gri", "grn", "grr", "grt", "grx" }):each(function(key) pcall(vim.keymap.del, "n", key) end)

vim.keymap.set({ "n", "x" }, "s", "<nop>")
vim.keymap.set({ "n", "x" }, "<c-o>", "<nop>")
vim.keymap.set("n", "<c-d>", "<c-d>zz", { desc = "Half page down" })
vim.keymap.set("n", "<c-u>", "<c-u>zz", { desc = "Half page up" })
vim.keymap.set("t", "<c-q>", "<c-\\><c-n>", { desc = "Normal mode" })

vim.keymap.set({ "n", "x", "i", "t" }, "<c-h>", function() require("helpers").zellij.move("left") end, { desc = "Move left" })
vim.keymap.set({ "n", "x", "i", "t" }, "<c-j>", function() require("helpers").zellij.move("down") end, { desc = "Move down" })
vim.keymap.set({ "n", "x", "i", "t" }, "<c-k>", function() require("helpers").zellij.move("up") end, { desc = "Move up" })
vim.keymap.set({ "n", "x", "i", "t" }, "<c-l>", function() require("helpers").zellij.move("right") end, { desc = "Move right" })

for _, map in ipairs({
  { "<m-h>", "vertical resize", -1, "Shrink width" },
  { "<m-j>", "resize", 1, "Grow height" },
  { "<m-k>", "resize", -1, "Shrink height" },
  { "<m-l>", "vertical resize", 1, "Grow width" },
}) do
  vim.keymap.set({ "n", "t" }, map[1], function()
    local delta = map[3] * 2 * (vim.v.count1 > 0 and vim.v.count1 or 1)
    vim.cmd(("%s %s%d"):format(map[2], delta > 0 and "+" or "", delta))
  end, { desc = map[4] })
end

vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, silent = true, desc = "Previous search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, silent = true, desc = "Previous search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, silent = true, desc = "Previous search result" })
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, silent = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, silent = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, silent = true, desc = "Next search result" })
vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous" })
vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next" })
vim.keymap.set("n", "<leader>-", "<cmd>split<cr>", { desc = "Split (H)" })
vim.keymap.set("n", "<leader><tab>G", "<cmd>tablast<cr>", { desc = "Last" })
vim.keymap.set("n", "<leader><tab>e", "<cmd>tabedit %<cr>", { desc = "Edit" })
vim.keymap.set("n", "<leader><tab>g", "<cmd>tabfirst<cr>", { desc = "First" })
vim.keymap.set("n", "<leader><tab>k", "<cmd>tabonly<cr>", { desc = "Keep" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New" })
vim.keymap.set("n", "<leader><tab>q", "<cmd>tabclose<cr>", { desc = "Close" })
vim.keymap.set("n", "<leader>\\", "<cmd>vsplit<cr>", { desc = "Split (V)" })
vim.keymap.set("n", "<leader>bk", require("helpers").keep_current_buffer, { desc = "Keep this" })
vim.keymap.set("n", "<leader>bG", "<cmd>blast<cr>", { desc = "Last" })
vim.keymap.set("n", "<leader>bg", "<cmd>bfirst<cr>", { desc = "First" })
vim.keymap.set("n", "<leader>q", require("helpers").quit_or_detach, { desc = "Quit" })

vim.keymap.set("n", "<leader>u", function()
  vim.cmd.packadd("nvim.undotree")
  vim.cmd.Undotree()
end, { desc = "Undo Tree" })
