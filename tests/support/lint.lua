local T = require("test_helper")

local M = {}

-- Runs configs.plugins.lint.setup() against a stubbed nvim-lint and returns that stub, so a test
-- can inspect the resulting linters_by_ft without registering real autocmds.
function M.setup_lint()
  local lint = { linters_by_ft = {}, linters = { pylint = {} }, try_lint = function() end }
  T.with_modules({
    lint = lint,
    ["utils.python_env"] = {
      pylint_command = function()
        return "pylint"
      end,
    },
  }, function()
    T.stub(vim.api, "nvim_create_autocmd", function() end)
    require("configs.plugins.lint").setup()
  end)
  return lint
end

return M
