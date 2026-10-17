local T = require("test_helper")

T.test("Go DAP spec is limited to Go buffers and delegates setup through opts", function()
  local spec = require("plugins.dap-go")
  T.eq(spec[1], "leoluz/nvim-dap-go")
  T.eq(spec.ft, "go")
  T.eq(spec.opts ~= nil, true)
  T.eq(spec.dependencies[1], "mfussenegger/nvim-dap")
end)
