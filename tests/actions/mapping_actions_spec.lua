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

T.test("mapping actions delegate inlay hints, buffers, terminals and DAP calls", function()
  local state, calls = false, {}
  T.stub(vim.api, "nvim_get_current_buf", function()
    return 8
  end)
  T.stub(vim.api, "nvim_get_current_win", function()
    return 4
  end)
  T.stub(vim.api, "nvim_win_close", function(win, force)
    calls[#calls + 1] = { win, force }
  end)
  T.stub(
    vim,
    "bo",
    setmetatable({}, {
      __index = function(_, buf)
        return { buftype = buf == 8 and "terminal" or "" }
      end,
    })
  )
  local notifications = {}
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
  T.with_modules({
    ["nvchad.tabufline"] = {
      next = function()
        calls[#calls + 1] = "next"
      end,
      prev = function()
        calls[#calls + 1] = "prev"
      end,
      close_buffer = function()
        calls[#calls + 1] = "buffer close"
      end,
    },
    ["nvchad.term"] = {
      new = function(opts)
        calls[#calls + 1] = opts
      end,
    },
    ["dap-go"] = {
      debug_test = function()
        calls[#calls + 1] = "go"
      end,
      debug_last_test = function()
        calls[#calls + 1] = "last"
      end,
    },
    ["dap-python"] = {
      test_method = function()
        calls[#calls + 1] = "python"
      end,
    },
    dapui = {
      toggle = function()
        calls[#calls + 1] = "ui"
      end,
    },
  }, function()
    actions.toggle_inlay_hints()
    T.eq(state, true)
    T.eq(notifications[1], "Inlay hints enabled")
    actions.toggle_inlay_hints()
    T.eq(state, false)
    T.eq(notifications[2], "Inlay hints disabled")
    actions.close_terminal()
    T.eq(calls[#calls][1], 4)
    vim.bo = setmetatable({}, {
      __index = function()
        return { buftype = "" }
      end,
    })
    local closed = #calls
    actions.close_terminal()
    T.eq(#calls, closed)
    actions.new_horizontal_terminal()
    T.eq(calls[#calls].pos, "sp")
    T.eq(calls[#calls].size, 0.5)
    actions.next_buffer()
    actions.previous_buffer()
    actions.close_buffer()
    actions.debug_go_test()
    actions.debug_last_go_test()
    actions.debug_python_test()
    actions.toggle_dap_ui()
  end)
  T.eq(calls[1][1], 4)
  T.eq(calls[1][2], true)
  T.eq(table.concat({ calls[2].pos, calls[2].size }, ","), "sp,0.5")
  T.eq(
    table.concat({ calls[3], calls[4], calls[5], calls[6], calls[7], calls[8], calls[9] }, ","),
    "next,prev,buffer close,go,last,python,ui"
  )
end)
