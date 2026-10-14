local T = require("test_helper")

T.test("DAP UI setup registers setup and closes UI after termination or exit", function()
  local setup_calls, close_calls = 0, 0
  local dap = { listeners = { before = { event_terminated = {}, event_exited = {} } } }
  local dapui = {
    setup = function()
      setup_calls = setup_calls + 1
    end,
    close = function()
      close_calls = close_calls + 1
    end,
  }

  T.with_modules({ dap = dap, dapui = dapui }, function()
    require("configs.plugins.dap-ui").setup()
  end)

  dap.listeners.before.event_terminated.dapui_config()
  dap.listeners.before.event_exited.dapui_config()
  T.eq(setup_calls, 1)
  T.eq(close_calls, 2)
end)
