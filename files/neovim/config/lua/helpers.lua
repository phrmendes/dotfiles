local M = {}
M.mini = {}

--- Get the words from a dictionary file.
--- @param lang string The language of the dictionary.
--- @return string[]: A list of words.
M.get_dictionary_words = function(lang)
  local file = vim.fs.joinpath(vim.env.HOME, "Documents", "notes", "dictionaries", lang .. ".add")

  if not vim.uv.fs_stat(file) then
    if not vim.api.nvim_list_uis()[1] then return {} end
    vim.notify("File does not exist: " .. file, vim.log.levels.WARN)
    return {}
  end

  return vim.fn.readfile(file)
end

--- Add a word to a dictionary file.
--- @param lang string The language of the dictionary.
--- @param word string The word to add.
--- @return string[]: A list of unique words.
M.add_word_to_dictionary = function(lang, word)
  local file = vim.fs.joinpath(vim.env.HOME, "Documents", "notes", "dictionaries", lang .. ".add")
  local words = vim.uv.fs_stat(file) and vim.fn.readfile(file) or {}
  local set = {}

  for _, w in ipairs(words) do
    w = vim.trim(w)
    if w ~= "" then set[w] = true end
  end

  set[vim.trim(word)] = true

  local unique = vim.tbl_keys(set)
  table.sort(unique)
  vim.fn.writefile(unique, file)

  return unique
end

--- Returns all subdirectories under a path. The path is absolute.
--- @param path string The path to search for subdirectories.
--- @return string[]: A list of subdirectory paths.
M.get_subdirectories = function(path)
  return vim
    .iter(vim.fs.dir(path))
    :filter(function(_, type) return type == "directory" end)
    :map(function(name, _) return vim.fs.joinpath(path, name) end)
    :totable()
end

--- Pick from listed buffers with <c-d> to delete.
M.mini.buffers = function()
  local buf_items = function()
    return vim
      .iter(vim.fn.getbufinfo({ buflisted = 1 }))
      :map(function(buf)
        local text
        if vim.bo[buf.bufnr].buftype == "terminal" then
          text = vim.fn.fnamemodify(buf.name, ":t")
        else
          local name = vim.fn.fnamemodify(buf.name, ":~:.")
          text = name ~= "" and name or "[No Name]"
        end
        return { bufnr = buf.bufnr, text = text }
      end)
      :totable()
  end

  MiniPick.start({
    source = {
      name = "Buffers",
      items = buf_items(),
      show = function(buf_id, items, query) MiniPick.default_show(buf_id, items, query, { show_icons = true }) end,
      choose = function(item)
        local win_target = MiniPick.get_picker_state().windows.target
        vim.api.nvim_win_set_buf(win_target, item.bufnr)
      end,
    },
    mappings = {
      wipeout = {
        char = "<c-d>",
        func = function()
          local matches = MiniPick.get_picker_matches()
          if not matches then return end
          local to_delete = matches.marked and #matches.marked > 0 and matches.marked or { matches.current }
          vim.iter(to_delete):each(function(buf)
            if buf then MiniBufremove.delete(buf.bufnr) end
          end)
          MiniPick.set_picker_items(buf_items())
        end,
      },
    },
  })
end

--- Find all git repos under ~/Projects and open them with MiniPick.
--- Projects are sorted by recency (via mini.visits), falling back to alphabetical.
--- On selection, changes cwd for the current tab and opens mini.files.
M.mini.project = function()
  local root = vim.fs.joinpath(vim.env.HOME, "Projects")
  local command = { "fd", "--type", "d", "--hidden", "--max-depth", "3", ".", root }

  local postprocess = function(lines)
    local sort = MiniVisits.gen_sort.default({ recency_weight = 1 })
    local visited = MiniVisits.list_paths("", { sort = sort })
    local recency = {}

    vim.iter(ipairs(visited)):each(function(i, path)
      local project = vim.fs.root(path, ".git")
      if project and not recency[project] then recency[project] = i end
    end)

    local items = vim
      .iter(lines)
      :map(function(dir) return dir:gsub("/$", "") end)
      :map(function(dir)
        local stat = vim.uv.fs_stat(vim.fs.joinpath(dir, ".git"))
        if not stat then return nil end
        local prefix = stat.type == "file" and "[S] " or ""
        return {
          text = prefix .. vim.fn.fnamemodify(dir, ":~"),
          path = dir,
          recency = recency[dir] or math.huge,
        }
      end)
      :filter(function(item) return item ~= nil end)
      :totable()

    table.sort(items, function(a, b)
      if a.recency ~= b.recency then return a.recency < b.recency end
      return a.text < b.text
    end)

    return items
  end

  MiniPick.builtin.cli({ command = command, postprocess = postprocess }, {
    source = {
      name = "Projects",
      show = function(buf_id, items_, query) MiniPick.default_show(buf_id, items_, query, { show_icons = true }) end,
      choose = function(item)
        if not item then return end
        vim.schedule(function()
          vim.cmd.tchdir(item.path)
          MiniFiles.close()
          MiniFiles.open(item.path, false)
        end)
      end,
    },
  })
end

--- Toggle a centered zoom with a dimmed backdrop.
M.zoom = function()
  local width = 120
  local col = math.floor((vim.o.columns - width) / 2)
  local zoomed_in = MiniMisc.zoom(0, { width = width, col = col, zindex = 51 })

  if not zoomed_in then return end

  vim.api.nvim_set_hl(0, "ReadingModeBackdrop", { bg = "#000000" })
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    row = 0,
    col = 0,
    width = vim.o.columns,
    height = vim.o.lines,
    focusable = false,
    style = "minimal",
    zindex = 50,
  })

  vim.wo[win].winblend = 60
  vim.wo[win].winhighlight = "Normal:ReadingModeBackdrop"

  local zoom_win = vim.api.nvim_get_current_win()

  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(zoom_win),
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
      if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
    end,
  })
end

--- Quit if embedded, otherwise detach.
M.quit_or_detach = function()
  if vim.list_contains(vim.v.argv, "--embed") then
    vim.cmd.quit()
    return
  end

  vim.cmd.detach()
end

--- Delete all buffers except the current one.
M.keep_current_buffer = function()
  local current = vim.api.nvim_get_current_buf()

  vim
    .iter(vim.api.nvim_list_bufs())
    :filter(function(buf) return buf ~= current and vim.bo[buf].buflisted end)
    :each(function(buf) require("mini.bufremove").delete(buf) end)
end

--- Pick a Zotero reference using mini.pick.
--- Replaces zotcite's default Telescope picker.
--- @param key string Pattern to filter references by author or title.
--- @param cb function Callback receiving the selected reference as `{ value = item }`.
M.zotcite_refs = function(key, cb)
  local zotero = require("zotcite.zotero")
  local zconfig = require("zotcite.config").get_config()

  local pattern = key:gsub(" .*", "")
  local matches = zotero.get_match(pattern, vim.api.nvim_buf_get_name(0))

  if #matches == 0 then
    vim.schedule(function() vim.api.nvim_echo({ { "No matches found." } }, false, {}) end)
    return
  end

  local items = vim
    .iter(matches)
    :map(
      function(v)
        return {
          text = string.format("%-20s  %4s  %s", v.alastnm or "", v.year or "", v.title or ""),
          sort_val = v[zconfig.sort_key] or "0000-00-00 0000",
          alastnm = v.alastnm,
          year = v.year,
          title = v.title,
          abstract = v.abstractNote,
          key = v.zotkey,
          cite = v.citekey,
        }
      end
    )
    :totable()

  table.sort(items, function(a, b) return a.sort_val > b.sort_val end)

  vim.cmd("stopinsert")

  MiniPick.start({
    source = {
      items = items,
      name = "Zotero References",
      choose = function(item)
        if item then vim.schedule(function() cb({ value = item }) end) end
      end,
    },
  })
end

return M
