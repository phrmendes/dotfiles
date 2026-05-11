return function(input_line_number, cursor_line, cursor_column)
  local site = vim.fn.stdpath("data") .. "/site"

  vim.opt.runtimepath:prepend({ site, site .. "/pack/core/opt/mini.nvim" })

  require("mini.base16").setup({ palette = require("nix").base16.palette, use_cterm = true })

  vim.opt.compatible = false
  vim.opt.encoding = "utf-8"
  vim.opt.clipboard = "unnamedplus"
  vim.opt.termguicolors = true
  vim.opt.scrollback = 100000
  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.showmode = false
  vim.opt.showcmd = false
  vim.opt.ruler = false
  vim.opt.laststatus = 2
  vim.o.cmdheight = 0

  local buf = vim.api.nvim_create_buf(true, false)
  local chan = vim.api.nvim_open_term(buf, {})
  local group = vim.api.nvim_create_augroup("scrollback", {})

  vim.api.nvim_buf_set_keymap(buf, "n", "<esc>", "<cmd>q<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "yy", "yy<cmd>q<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "v", "y", "y<cmd>q<cr>", {})

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    buffer = buf,
    callback = function() vim.highlight.on_yank() end,
  })

  local set_cursor = function()
    local max_line = vim.api.nvim_buf_line_count(buf)
    local target_line = math.min(cursor_line, max_line)

    vim.api.nvim_feedkeys(tostring(input_line_number) .. "ggzt", "n", true)
    vim.api.nvim_feedkeys(tostring(target_line - 1) .. "j", "n", true)
    vim.api.nvim_feedkeys("0", "n", true)
    vim.api.nvim_feedkeys(tostring(cursor_column - 1) .. "l", "n", true)
  end

  vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    buffer = buf,
    callback = function()
      if vim.fn.mode() == "t" then
        vim.cmd.stopinsert()
        vim.schedule(set_cursor)
      end
    end,
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    pattern = "*",
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
      vim.defer_fn(set_cursor, 10)
    end,
  })
end
