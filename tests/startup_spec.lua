local T = require("test_helper")

T.test("init.lua starts with stubbed Lazy and base46 cache in isolated state", function()
  local root = vim.fn.tempname()
  local cache = root .. "/nvchad/base46"
  vim.fn.mkdir(cache, "p")
  vim.fn.writefile({ "vim.g.test_base46_defaults = true" }, cache .. "/defaults")
  vim.fn.writefile({ "vim.g.test_base46_statusline = true" }, cache .. "/statusline")
  T.cleanup(function()
    vim.fn.delete(root, "rf")
  end)

  local rtp = vim.o.rtp
  T.cleanup(function()
    vim.o.rtp = rtp
  end)
  T.stub(vim.fn, "stdpath", function(name)
    T.eq(name, "data")
    return root
  end)
  T.stub(vim.uv, "fs_stat", function()
    return { type = "directory" }
  end)
  T.stub(vim, "schedule", function(callback)
    callback()
  end)

  local setup_args
  T.with_modules({
    lazy = {
      setup = function(specs, opts)
        setup_args = { specs, opts }
      end,
    },
    autocmds = true,
    mappings = true,
  }, function()
    dofile("init.lua")
  end)

  T.eq(type(setup_args), "table")
  T.eq(setup_args[1][1][1], "NvChad/NvChad")
  T.eq(setup_args[1][2].import, "plugins")
  T.eq(vim.g.test_base46_defaults, true)
  T.eq(vim.g.test_base46_statusline, true)
end)
