local has_nix, nix = pcall(require, "nix")

--- @class theme.Opts mini.base16 options, `palette` is always `nix.colors`. Ignored by the fallback.
--- @field use_cterm? boolean|table<string, integer> `true` derives cterm colors from the palette
--- @field plugins? table<string, boolean|table> plugin integrations, `{ default = false }` disables all

--- Apply mini.base16 with the Nix palette, or mini.hues with a brown background and an orange foreground.
--- @param opts? theme.Opts
return function(opts)
  if has_nix and nix.colors then
    require("mini.base16").setup(vim.tbl_extend("force", { palette = nix.colors }, opts or {}))
    return
  end

  require("mini.hues").setup({
    background = "#202020",
    foreground = "#e78a4e",
    n_hues = 8,
    saturation = "medium",
    accent = "bg",
  })
end
