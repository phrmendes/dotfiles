local version = "v0.27.1"
local bin = vim.fs.joinpath(vim.fn.stdpath("data"), "bin")
local archs = { x86_64 = "x64", aarch64 = "arm64" }
local missing = require("helpers").missing
local parsers = {
  "bash",
  "bibtex",
  "c",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "dot",
  "go",
  "hcl",
  "helm",
  "html",
  "hurl",
  "java",
  "javascript",
  "json",
  "latex",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "nix",
  "nu",
  "python",
  "ron",
  "ruby",
  "rust",
  "sql",
  "svelte",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "xml",
  "yaml",
}

local function warn(message)
  vim.schedule(function() vim.notify("tree-sitter download failed: " .. vim.trim(message), vim.log.levels.WARN) end)
end

safely("now", function()
  local treesitter = require("nvim-treesitter")
  local installed = treesitter.get_installed()
  local pending = vim.iter(parsers):filter(function(lang) return not vim.list_contains(installed, lang) end):totable()

  if #pending == 0 or missing("cc") then return end

  vim.env.PATH = vim.env.PATH .. ":" .. bin

  if not missing("tree-sitter") then return treesitter.install(pending) end

  local uname = vim.uv.os_uname()
  if not uname then return end
  local arch = archs[uname.machine]

  if uname.sysname ~= "Linux" or not arch or missing("curl", "gzip") then return end

  local archive = vim.fs.joinpath(bin, "tree-sitter.gz")
  local url = ("https://github.com/tree-sitter/tree-sitter/releases/download/%s/tree-sitter-linux-%s.gz"):format(version, arch)

  vim.fn.mkdir(bin, "p")

  vim.net.request(url, { outpath = archive }, function(err)
    if err then return warn(err) end

    vim.system({ "gzip", "-df", archive }, {}, function(result)
      if result.code ~= 0 then
        vim.fs.rm(archive, { force = true })
        return warn(result.stderr)
      end

      vim.uv.fs_chmod(vim.fs.joinpath(bin, "tree-sitter"), tonumber("755", 8))
      vim.schedule(function() treesitter.install(pending) end)
    end)
  end)
end)
