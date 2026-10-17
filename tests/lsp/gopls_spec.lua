local T = require("test_helper")

T.test("gopls config enables expected analysis and inlay hints", function()
  local settings = dofile("lsp/gopls.lua").settings.gopls
  T.eq(settings.completeUnimported, true)
  T.eq(settings.analyses.unusedparams, true)
  for _, hint in ipairs({
    "assignVariableTypes",
    "compositeLiteralFields",
    "compositeLiteralTypes",
    "parameterNames",
    "rangeVariableTypes",
  }) do
    T.eq(settings.hints[hint], true, "missing gopls hint: " .. hint)
  end
end)
