vim.keymap.del("n", "gra")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "grn")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grt")

-- random
vim.keymap.set({ "n", "x" }, "s", "<nop>")
vim.keymap.set("n", "<c-d>", "<c-d>zz", { noremap = true, desc = "Half page down" })
vim.keymap.set("n", "<c-u>", "<c-u>zz", { noremap = true, desc = "Half page up" })

-- better default keys
vim.keymap.set("n", "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true, noremap = true, silent = true })
vim.keymap.set("n", "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true, noremap = true, silent = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, noremap = true, silent = true })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, noremap = true, silent = true })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, noremap = true, silent = true })
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, noremap = true, silent = true })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, noremap = true, silent = true })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, noremap = true, silent = true })
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { silent = true })

-- leader keys
vim.keymap.set("n", "<leader><leader>", "<c-^>", { noremap = true, desc = "Alternate file" })
vim.keymap.set("n", "<leader>-", "<cmd>split<cr>", { noremap = true, desc = "Split (H)" })
vim.keymap.set("n", "<leader>\\", "<cmd>vsplit<cr>", { noremap = true, desc = "Split (V)" })
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo Tree" })
vim.keymap.set("n", "<leader>w", "<cmd>silent w!<cr>", { noremap = true, desc = "Write" })

vim.keymap.set("n", "<leader>T", function()
  vim.ui.input({ prompt = "Name: " }, function(name)
    if name then vim.cmd("terminal zsh \\# " .. name) end
  end)
end, { noremap = true, desc = "Open new terminal" })

vim.keymap.set("n", "<leader>q", function()
  if vim.list_contains(vim.v.argv, "--embed") then
    vim.cmd.quit()
    return
  end

  vim.cmd.detach()
end, { noremap = true, desc = "Quit" })

-- buffer keys
vim.keymap.set("n", "<leader>bG", "<cmd>blast<cr>", { noremap = true, desc = "Last" })
vim.keymap.set("n", "<leader>bg", "<cmd>bfirst<cr>", { noremap = true, desc = "First" })
vim.keymap.set("n", "<leader>bk", "<cmd>wall!<bar>%bdelete<bar>edit#<bar>bdelete#<cr>", {
  noremap = true,
  desc = "Keep this",
})

-- tab keys
vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>", { noremap = true, desc = "Previous" })
vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>", { noremap = true, desc = "Next" })
vim.keymap.set("n", "<leader><tab>G", "<cmd>tablast<cr>", { noremap = true, desc = "Last" })
vim.keymap.set("n", "<leader><tab>q", "<cmd>tabclose<cr>", { noremap = true, desc = "Close" })
vim.keymap.set("n", "<leader><tab>g", "<cmd>tabfirst<cr>", { noremap = true, desc = "First" })
vim.keymap.set("n", "<leader><tab>k", "<cmd>tabonly<cr>", { noremap = true, desc = "Keep" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>", { noremap = true, desc = "New" })
vim.keymap.set("n", "<leader><tab>e", "<cmd>tabedit %<cr>", { noremap = true, desc = "Edit" })
