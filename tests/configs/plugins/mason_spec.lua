local T = require("test_helper")

local with_mason_mocks = require("support.mason").with_mason_mocks

T.test("Mason skips packages that are already installed", function()
  local install_calls = 0
  with_mason_mocks({
    refresh = function(callback)
      callback(true)
    end,
    get_package = function()
      return {
        is_installed = function()
          return true
        end,
        install = function()
          install_calls = install_calls + 1
        end,
      }
    end,
  }, function()
    require("configs.plugins.mason").setup({ ensure_installed = { "tool" } })
    T.eq(install_calls, 0)
  end)
end)

T.test("Mason setup accepts a missing ensure_installed list", function()
  local refreshes = 0
  with_mason_mocks({
    refresh = function(callback)
      refreshes = refreshes + 1
      callback(true)
    end,
    get_package = function()
      error("no package should be requested")
    end,
  }, function()
    require("configs.plugins.mason").setup({})
  end)
  T.eq(refreshes, 1)
end)

T.test("Mason reports an install that closes without installing", function()
  local notifications, install_closed = {}, nil
  T.stub(vim, "notify", function(message, level)
    notifications[#notifications + 1] = { message = message, level = level }
  end)
  T.stub(vim, "schedule", function(callback)
    callback()
  end)

  with_mason_mocks({
    refresh = function(callback)
      callback(true)
    end,
    get_package = function(name)
      T.eq(name, "tool")
      return {
        is_installed = function()
          return false
        end,
        install = function()
          return {
            once = function(_, event, callback)
              T.eq(event, "closed")
              install_closed = callback
            end,
          }
        end,
      }
    end,
  }, function()
    require("configs.plugins.mason").setup({ ensure_installed = { "tool" } })
  end)
  assert(type(install_closed) == "function")
  install_closed()
  T.eq(#notifications, 1)
  T.eq(notifications[1].message, "Mason: failed to install tool")
  T.eq(notifications[1].level, vim.log.levels.ERROR)
end)

T.test("Mason does not report a failed install after the package is installed", function()
  local notifications, installed, install_closed = {}, false, nil
  T.stub(vim, "notify", function(message)
    notifications[#notifications + 1] = message
  end)
  T.stub(vim, "schedule", function(callback)
    callback()
  end)

  with_mason_mocks({
    refresh = function(callback)
      callback(true)
    end,
    get_package = function()
      return {
        is_installed = function()
          return installed
        end,
        install = function()
          return {
            once = function(_, _, callback)
              install_closed = callback
            end,
          }
        end,
      }
    end,
  }, function()
    require("configs.plugins.mason").setup({ ensure_installed = { "tool" } })
  end)
  assert(type(install_closed) == "function")
  installed = true
  install_closed()
  T.eq(#notifications, 0)
end)

T.test("Mason reports registry refresh failure and skips package lookup", function()
  local notifications, lookups = {}, 0
  T.stub(vim, "notify", function(message, level)
    notifications[#notifications + 1] = { message = message, level = level }
  end)

  with_mason_mocks({
    refresh = function(callback)
      callback(false)
    end,
    get_package = function()
      lookups = lookups + 1
    end,
  }, function()
    require("configs.plugins.mason").setup({ ensure_installed = { "tool" } })
  end)
  T.eq(lookups, 0)
  T.eq(notifications[1].message, "Mason registry refresh failed")
  T.eq(notifications[1].level, vim.log.levels.ERROR)
end)

T.test("Mason reports package names missing from the refreshed registry", function()
  local notifications = {}
  T.stub(vim, "notify", function(message, level)
    notifications[#notifications + 1] = { message = message, level = level }
  end)

  with_mason_mocks({
    refresh = function(callback)
      callback(true)
    end,
    get_package = function()
      error("package missing")
    end,
  }, function()
    require("configs.plugins.mason").setup({ ensure_installed = { "unknown-tool" } })
  end)
  T.eq(notifications[1].message, "Mason: unknown package unknown-tool")
  T.eq(notifications[1].level, vim.log.levels.ERROR)
end)
