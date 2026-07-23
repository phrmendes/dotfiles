safely("later", function()
  require("mini.files").setup({
    windows = { preview = true },
    mappings = {
      close = "q",
      go_in = "l",
      go_in_plus = "<cr>",
      go_out = "h",
      go_out_plus = "H",
      reset = "<bs>",
      reveal_cwd = "@",
      show_help = "?",
      synchronize = "=",
      trim_left = "<",
      trim_right = ">",
    },
  })

  vim.api.nvim_create_autocmd("User", {
    desc = "Set mini.files keybindings",
    pattern = "MiniFilesBufferCreate",
    callback = function(event)
      local bufnr = event.data.buf_id

      local split = function(direction)
        return function()
          local win = MiniFiles.get_explorer_state().target_window
          if win then
            local new_win
            vim.api.nvim_win_call(win, function()
              vim.cmd("belowright " .. direction .. " split")
              new_win = vim.api.nvim_get_current_win()
            end)
            MiniFiles.set_target_window(new_win)
            MiniFiles.go_in({ close_on_file = true })
          end
        end
      end

      vim.keymap.set("n", "-", split("horizontal"), { buffer = bufnr, desc = "Open file (split)" })
      vim.keymap.set("n", "\\", split("vertical"), { buffer = bufnr, desc = "Open file (vsplit)" })

      vim.keymap.set("n", ".", function()
        vim.g.mini_show_dotfiles = not vim.g.mini_show_dotfiles
        MiniFiles.refresh({
          content = {
            filter = vim.g.mini_show_dotfiles and function() return true end or function(fs_entry) return not vim.startswith(fs_entry.name, ".") end,
          },
        })
      end, { buffer = bufnr, desc = "Toggle dotfiles" })

      vim.keymap.set("n", "go", function()
        local fs_entry = MiniFiles.get_fs_entry()
        if not fs_entry then return vim.notify("No file selected", vim.log.levels.ERROR) end
        vim.schedule(function()
          vim.notify("Opening " .. fs_entry.name, vim.log.levels.INFO)
          vim.ui.open(fs_entry.path)
        end)
      end, { buffer = bufnr, desc = "Open file" })

      vim.keymap.set("n", "gs", function()
        local grug_far = require("grug-far")
        local prefills = { paths = vim.fs.dirname(MiniFiles.get_fs_entry().path) }
        if not grug_far.has_instance("explorer") then
          grug_far.open({ instanceName = "explorer", prefills = prefills, staticTitle = "Find and Replace from Explorer" })
        else
          grug_far.get_instance("explorer"):open()
          grug_far.get_instance("explorer"):update_input_values(prefills, false)
        end
      end, { buffer = bufnr, desc = "Search with grug-far.nvim" })
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    desc = "Set border for mini.files window",
    pattern = "MiniFilesWindowOpen",
    callback = function(event) vim.api.nvim_win_set_config(event.data.win_id, { border = vim.g.border }) end,
  })

  vim.keymap.set("n", "<leader>e", function()
    if not MiniFiles.close() then
      local path = vim.fn.expand("%:p:h")
      MiniFiles.open(vim.uv.fs_stat(path) and path or nil, true)
    end
  end, { desc = "Explorer" })
end)
