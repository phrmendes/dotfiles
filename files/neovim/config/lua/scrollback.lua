return function(input_line_number, cursor_line, cursor_column)
  local site = vim.fn.stdpath("data") .. "/site"

  vim.opt.runtimepath:prepend({ site, site .. "/pack/core/opt/mini.nvim" })

  require("mini.base16").setup({ palette = require("nix").colors, use_cterm = true })

  require("mini.jump2d").setup({
    mappings = { start_jumping = "<space>j" },
    spotter = require("mini.jump2d").gen_spotter.pattern("[^%s%p]+"),
    view = { dim = true, n_steps_ahead = 2 },
  })

  vim.opt.clipboard = "unnamedplus"
  vim.opt.scrollback = 100000
  vim.opt.laststatus = 2
  vim.o.cmdheight = 0

  local buf = vim.api.nvim_create_buf(true, false)
  local chan = vim.api.nvim_open_term(buf, {})

  for _, lhs in ipairs({ "q", "<esc>" }) do
    vim.keymap.set("n", lhs, "<cmd>q<cr>", { buffer = buf })
  end

  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function(ev)
      local win = vim.fn.win_getid()
      local all_lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
      local last = table.remove(all_lines)

      vim.api.nvim_chan_send(chan, table.concat(all_lines, "\r\n") .. "\r\n")
      vim.api.nvim_chan_send(chan, last)

      vim.api.nvim_win_set_buf(win, buf)
      vim.api.nvim_buf_delete(ev.buf, { force = true })
      vim.wo[win].statusline = "  Scrollback %=%l/%L "

      vim.defer_fn(function()
        vim.cmd.stopinsert()
        vim.schedule(function()
          vim.cmd.normal({ input_line_number .. "Gzt", bang = true })
          local row = math.min(input_line_number + cursor_line - 1, vim.api.nvim_buf_line_count(buf))
          vim.api.nvim_win_set_cursor(win, { row, cursor_column - 1 })
        end)
      end, 10)
    end,
  })
end
