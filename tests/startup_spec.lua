local T = require("test_helper")

T.test("init.lua starts with stubbed Lazy and base46 cache in isolated state", function()
  local root = vim.fn.tempname()
  local cache = root .. "/nvchad/base46"
  vim.fn.mkdir(cache, "p")
  vim.fn.writefile({ "vim.g.test_base46_defaults = true" }, cache .. "/defaults")
  vim.fn.writefile({ "vim.g.test_base46_statusline = true" }, cache .. "/statusline")

  local saved = {
    stdpath = vim.fn.stdpath,
    fs_stat = vim.uv.fs_stat,
    schedule = vim.schedule,
    rtp = vim.o.rtp,
    mapleader = vim.g.mapleader,
    defaults = vim.g.test_base46_defaults,
    statusline = vim.g.test_base46_statusline,
  }
  vim.fn.stdpath = function(name)
    T.eq(name, "data")
    return root
  end
  vim.uv.fs_stat = function()
    return { type = "directory" }
  end
  vim.schedule = function(callback)
    callback()
  end

  local setup_args
  local ok, err = pcall(function()
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

  vim.fn.stdpath = saved.stdpath
  vim.uv.fs_stat = saved.fs_stat
  vim.schedule = saved.schedule
  vim.o.rtp = saved.rtp
  vim.g.mapleader = saved.mapleader
  vim.g.test_base46_defaults = saved.defaults
  vim.g.test_base46_statusline = saved.statusline
  vim.fn.delete(root, "rf")
  assert(ok, err)
end)
