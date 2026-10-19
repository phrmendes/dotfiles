safely("later", function()
  require("lint").linters_by_ft = {
    astro = { "eslint" },
    bash = { "shellcheck" },
    htmldjango = { "djlint" },
    javascript = { "eslint" },
    jinja2 = { "djlint" },
    jsx = { "eslint" },
    rust = { "clippy" },
    sh = { "shellcheck" },
    terraform = { "tflint" },
    tsx = { "eslint" },
    typescript = { "eslint" },
    ["yaml.ansible"] = { "ansible_lint" },
  }

  safely("event:BufWritePost,BufReadPost,InsertLeave", function() require("lint").try_lint() end)
end)
