local T = require("test_helper")

T.test("DAP setup opens DAP UI before attach and launch", function()
  local dap = { listeners = { before = { attach = {}, launch = {} } } }
  local ui_calls = 0
  T.with_modules({
    dap = dap,
    dapui = {
      open = function()
        ui_calls = ui_calls + 1
      end,
    },
  }, function()
    require("configs.plugins.dap").setup()
    dap.listeners.before.attach.dapui_lazy_load()
    dap.listeners.before.launch.dapui_lazy_load()
  end)

  T.eq(ui_calls, 2)
end)
