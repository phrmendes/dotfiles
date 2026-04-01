return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      completion = { callSnippet = "Replace" },
      telemetry = { enable = false },
      diagnostics = {
        globals = { "vim", "Snacks", "ngx", "ndk" },
        disable = { "missing-fields" },
      },
      workspace = {
        library = {
          "${3rd}/OpenResty/library",
        },
        checkThirdParty = false,
      },
    },
  },
}
