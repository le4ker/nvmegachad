local T = require("test_helper")

T.test("Pyright config uses a project Python when one is detected", function()
  local python_path = "/workspace/.venv/bin/python"
  T.with_modules({
    ["utils.python_env"] = {
      python_path = function(root, is_directory)
        T.eq(root, "/workspace")
        T.eq(is_directory, true)
        return python_path
      end,
    },
  }, function()
    local config = dofile("lsp/pyright.lua")
    local server_config = { root_dir = "/workspace", settings = vim.deepcopy(config.settings) }
    config.before_init(nil, server_config)
    T.eq(server_config.settings.python.pythonPath, python_path)
    T.eq(server_config.settings.python.analysis.diagnosticMode, "workspace")
  end)
end)

T.test(
  "Pyright config leaves its Python path unchanged when no project interpreter is found",
  function()
    T.with_modules({
      ["utils.python_env"] = {
        python_path = function()
          return nil
        end,
      },
    }, function()
      local config = dofile("lsp/pyright.lua")
      local server_config = { root_dir = "/workspace", settings = vim.deepcopy(config.settings) }
      server_config.settings.python.pythonPath = "/system/python"
      config.before_init(nil, server_config)
      T.eq(server_config.settings.python.pythonPath, "/system/python")
    end)
  end
)
