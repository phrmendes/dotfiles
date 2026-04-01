safely(
  "later",
  function()
    require("lint").linters_by_ft = {
      htmldjango = { "djlint" },
      jinja2 = { "djlint" },
      terraform = { "tflint" },
    }
  end
)

safely("event:BufWritePost,BufReadPost,InsertLeave", function() require("lint").try_lint() end)
