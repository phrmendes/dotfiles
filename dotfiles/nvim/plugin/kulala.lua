later(function()
  vim.pack.add({ "https://github.com/mistweaverco/kulala.nvim" })

  require("kulala").setup({
    ui = {
      formatter = true,
      icons = { inlay = { done = "", error = "󰅚", loading = "" } },
      split_direction = "horizontal",
    },
    kulala_keymaps = {
      ["show headers"] = {
        "H",
        function() require("kulala.ui").show_headers() end,
      },
    },
  })

  vim.keymap.set("n", "<leader>ks", function() require("kulala").scratchpad() end, { desc = "Scratchpad" })

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Hide kulala buffer",
    group = vim.api.nvim_create_augroup("UserKulalaFileType", { clear = true }),
    pattern = "*kulala_ui",
    callback = function() vim.opt_local.buflisted = false end,
  })
end)
