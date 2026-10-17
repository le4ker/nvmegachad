local T = require("test_helper")

T.test("Conform plugin metadata and Python formatter options are configured", function()
  local spec = require("plugins.conform")
  local opts = spec.opts

  T.eq(spec[1], "stevearc/conform.nvim")
  T.eq(spec.event, "BufWritePre")

  assert(next(opts.formatters_by_ft), "Conform filetype map is empty")
  T.eq(table.concat(opts.formatters.isort.prepend_args, " "), "--profile black")
end)
