local T = require("test_helper")

T.test("format-on-save action toggles the global flag and reports the state", function()
  local actions = require("utils.mapping_actions")
  local notifications = {}
  T.stub(vim, "notify", function(message)
    notifications[#notifications + 1] = message
  end)
  vim.g.format_on_save = true
  actions.toggle_format_on_save()
  T.eq(vim.g.format_on_save, false)
  T.eq(notifications[#notifications], "Format on save disabled")

  actions.toggle_format_on_save()
  T.eq(vim.g.format_on_save, true)
  T.eq(notifications[#notifications], "Format on save enabled")
end)

T.test("diagnostic navigation requests previous and next items", function()
  local counts = {}
  T.stub(vim.diagnostic, "jump", function(opts)
    counts[#counts + 1] = opts.count
  end)
  local actions = require("utils.mapping_actions")
  actions.previous_diagnostic()
  actions.next_diagnostic()
  T.eq(table.concat(counts, ","), "-1,1")
end)

T.test(
  "Mason package update handles registry failure, current and installable outdated packages",
  function()
    local actions = require("utils.mapping_actions")
    local notices, installs, update_callback, opened, up_to_date = {}, {}, nil, 0, false
    local function pkg(name, installed, latest, installable)
      return {
        get_latest_version = function()
          return up_to_date and installed or latest
        end,
        get_installed_version = function()
          return installed
        end,
        is_installable = function(_, opts)
          T.eq(opts.version, latest)
          return installable
        end,
        install = function()
          installs[#installs + 1] = name
        end,
      }
    end
    local registry = {
      update = function(callback)
        update_callback = callback
      end,
      get_installed_packages = function()
        return {
          pkg("current", "1", "1", true),
          pkg("update", up_to_date and "2" or "1", "2", true),
          pkg("blocked", "1", "2", false),
        }
      end,
    }
    T.stub(vim, "cmd", function(command)
      T.eq(command, "Mason")
      opened = opened + 1
    end)
    T.stub(vim, "notify", function(message)
      notices[#notices + 1] = message
    end)
    T.with_modules({ ["mason-registry"] = registry }, function()
      actions.update_mason_packages()
      update_callback(false)
      T.eq(notices[#notices], "Mason registry update failed")
      update_callback(true)
      T.eq(notices[#notices], "Updating 1 Mason package(s)")
      up_to_date = true
      update_callback(true)
    end)
    T.eq(opened, 1)
    T.eq(table.concat(installs, ","), "update")
    T.eq(notices[#notices], "Mason packages are up to date")
  end
)

T.test("inlay hint action toggles the state and reports it", function()
  local state, notifications = false, {}
  T.stub(vim, "notify", function(message)
    notifications[#notifications + 1] = message
  end)
  T.stub(vim.lsp, "inlay_hint", {
    is_enabled = function()
      return state
    end,
    enable = function(value)
      state = value
    end,
  })
  local actions = require("utils.mapping_actions")

  actions.toggle_inlay_hints()
  T.eq(state, true)
  actions.toggle_inlay_hints()
  T.eq(state, false)
  T.eq(notifications, { "Inlay hints enabled", "Inlay hints disabled" })
end)

T.test("close_terminal force-closes the current window only for terminal buffers", function()
  local buftype, closed = "terminal", {}
  T.stub(vim.api, "nvim_get_current_buf", function()
    return 8
  end)
  T.stub(vim.api, "nvim_get_current_win", function()
    return 4
  end)
  T.stub(vim.api, "nvim_win_close", function(win, force)
    closed[#closed + 1] = { win, force }
  end)
  T.stub(
    vim,
    "bo",
    setmetatable({}, {
      __index = function()
        return { buftype = buftype }
      end,
    })
  )
  local actions = require("utils.mapping_actions")

  actions.close_terminal()
  T.eq(closed, { { 4, true } })

  buftype = ""
  actions.close_terminal()
  T.eq(closed, { { 4, true } }, "a non-terminal window must stay open")
end)

T.test("new_horizontal_terminal opens a half-height split", function()
  local opened = {}
  T.with_modules({
    ["nvchad.term"] = {
      new = function(opts)
        opened[#opened + 1] = opts
      end,
    },
  }, function()
    require("utils.mapping_actions").new_horizontal_terminal()
  end)
  T.eq(opened, { { pos = "sp", size = 0.5 } })
end)

-- Replaces a dependency with a module that records the name of every function called on it,
-- so each action is checked for calling exactly the expected function.
local function recording_module()
  local called = {}
  local module = setmetatable({}, {
    __index = function(_, name)
      return function()
        called[#called + 1] = name
      end
    end,
  })
  return module, called
end

local delegations = {
  { action = "next_buffer", module = "nvchad.tabufline", fn = "next" },
  { action = "previous_buffer", module = "nvchad.tabufline", fn = "prev" },
  { action = "close_buffer", module = "nvchad.tabufline", fn = "close_buffer" },
  { action = "debug_go_test", module = "dap-go", fn = "debug_test" },
  { action = "debug_last_go_test", module = "dap-go", fn = "debug_last_test" },
  { action = "debug_python_test", module = "dap-python", fn = "test_method" },
  { action = "toggle_dap_ui", module = "dapui", fn = "toggle" },
}

for _, case in ipairs(delegations) do
  T.test(("%s calls %s.%s"):format(case.action, case.module, case.fn), function()
    local module, called = recording_module()
    T.with_modules({ [case.module] = module }, function()
      require("utils.mapping_actions")[case.action]()
    end)
    T.eq(called, { case.fn }, case.action .. " must call exactly " .. case.module .. "." .. case.fn)
  end)
end
