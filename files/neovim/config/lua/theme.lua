local has_nix, nix = pcall(require, "nix")

--- @class theme.Opts mini.base16 options, `palette` is always `nix.colors`
--- @field use_cterm? boolean|table<string, integer> `true` derives cterm colors from the palette
--- @field plugins? table<string, boolean|table> plugin integrations, `{ default = false }` disables all

--- Apply the Nix palette with mini.base16, or fall back to the miniautumn colorscheme.
--- @param opts? theme.Opts
return function(opts)
  if has_nix and nix.colors then
    require("mini.base16").setup(vim.tbl_extend("force", { palette = nix.colors }, opts or {}))
    return
  end

  vim.cmd.colorscheme("miniautumn")
end
