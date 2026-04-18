local M = {}

--- Get the words from a dictionary file.
--- @param lang string The language of the dictionary.
--- @return string[]: A list of words.
M.get_dictionary_words = function(lang)
  local file = vim.fs.joinpath(vim.env.HOME, "Documents", "notes", "dictionaries", lang .. ".add")

  if not vim.uv.fs_stat(file) then
    vim.notify("File does not exist: " .. file, vim.log.levels.ERROR)
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

--- Paste the contents of the system clipboard.
--- @return table: A table containing clipboard lines and register type.
M.paste = function()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
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
