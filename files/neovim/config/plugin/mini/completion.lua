safely("later", function()
  require("mini.completion").setup({
    fallback_action = "<c-x><c-o>",
    window = {
      info = { height = 25, width = 80 },
      signature = { height = 25, width = 80 },
    },
    mappings = {
      force_twostep = "<c-f>",
      force_fallback = "<a-f>",
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    lsp_completion = {
      source_func = "omnifunc",
      auto_setup = false,
      process_items = function(items, base)
        return MiniCompletion.default_process_items(items, base, {
          kind_priority = { Text = -1, Snippet = 99 },
        })
      end,
    },
  })

  vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Disable completion in certain filetypes",
    pattern = { "dap-view", "dap-view-term", "dap-repl", "minifiles", "grug-far" },
    callback = function(event) vim.b[event.buf].minicompletion_disable = true end,
  })

  vim.api.nvim_create_autocmd("InsertCharPre", {
    desc = "Trigger path completion on /",
    callback = function()
      if vim.b.minicompletion_disable or vim.v.char ~= "/" then return end
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local line = vim.api.nvim_get_current_line()
      if line:sub(col, col) == "/" then vim.v.char = "" end
      vim.api.nvim_feedkeys(vim.keycode("<c-x><c-f>"), "n", false)
    end,
  })

  vim.api.nvim_create_autocmd("CompleteDone", {
    desc = "Retrigger path completion after accepting a directory",
    callback = function()
      if vim.v.event.complete_type == "files" and vim.v.event.reason == "accept" then vim.api.nvim_feedkeys("\24\6", "m", false) end
    end,
  })
end)
