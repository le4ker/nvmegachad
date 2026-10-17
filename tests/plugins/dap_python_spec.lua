local T = require("test_helper")

T.test("Python DAP setup uses Mason's debugpy interpreter", function()
  local original_stdpath = vim.fn.stdpath
  local setup_path
  vim.fn.stdpath = function(name)
    T.eq(name, "data")
    return "/nvim-data"
  end

  local ok, err = pcall(function()
    T.with_modules({
      ["dap-python"] = {
        setup = function(path)
          setup_path = path
        end,
      },
    }, function()
      local spec = require("plugins.dap-python")
      T.eq(spec.ft, "python")
      spec.config()
    end)
    T.eq(setup_path, "/nvim-data/mason/packages/debugpy/venv/bin/python")
  end)

  vim.fn.stdpath = original_stdpath
  assert(ok, err)
end)
