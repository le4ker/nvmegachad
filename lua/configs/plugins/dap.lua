local M = {}

function M.setup()
  local dap = require("dap")

  local function load_dapui()
    require("dapui").open()
  end

  dap.listeners.before.attach.dapui_lazy_load = load_dapui
  dap.listeners.before.launch.dapui_lazy_load = load_dapui
end

return M
