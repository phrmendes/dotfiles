return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      completion = { callSnippet = "Replace" },
      telemetry = { enable = false },
      diagnostics = {
        disable = { "missing-fields" },
        globals = { "hl" },
      },
      workspace = {
        library = { require("nix.neovim").hyprland },
        checkThirdParty = "ApplyInMemory",
      },
    },
  },
}
