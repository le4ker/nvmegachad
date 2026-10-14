local T = require("test_helper")

T.test("formatter returns nil when format-on-save is disabled", function()
  vim.g.format_on_save = false
  T.eq(require("utils.formatter").format_on_save(), nil)
end)

T.test("formatter uses LSP fallback and a one second timeout", function()
  vim.g.format_on_save = true
  local opts = require("utils.formatter").format_on_save()

  T.eq(opts.lsp_format, "fallback")
  T.eq(opts.timeout_ms, 1000)
end)
