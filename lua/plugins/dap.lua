return {
  "mfussenegger/nvim-dap",
  cmd = {
    "DapToggleBreakpoint",
    "DapContinue",
    "DapStepOver",
    "DapStepIn",
    "DapStepOut",
    "DapTerminate",
  },
  config = function()
    require("configs.plugins.dap").setup()
  end,
}
