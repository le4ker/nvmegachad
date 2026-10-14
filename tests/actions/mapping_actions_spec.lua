local T = require("test_helper")

T.test("format-on-save action toggles the global flag and reports the state", function()
  local actions = require("utils.mapping_actions")
  local original_notify = vim.notify
  local notifications = {}
  vim.notify = function(message)
    notifications[#notifications + 1] = message
  end

  local ok, err = pcall(function()
    vim.g.format_on_save = true
    actions.toggle_format_on_save()
    T.eq(vim.g.format_on_save, false)
    T.eq(notifications[#notifications], "Format on save disabled")

    actions.toggle_format_on_save()
    T.eq(vim.g.format_on_save, true)
    T.eq(notifications[#notifications], "Format on save enabled")
  end)
  vim.notify = original_notify
  assert(ok, err)
end)

T.test("diagnostic navigation requests previous and next items", function()
  local original_jump = vim.diagnostic.jump
  local counts = {}
  vim.diagnostic.jump = function(opts)
    counts[#counts + 1] = opts.count
  end

  local ok, err = pcall(function()
    local actions = require("utils.mapping_actions")
    actions.previous_diagnostic()
    actions.next_diagnostic()
    T.eq(counts[1], -1)
    T.eq(counts[2], 1)
  end)
  vim.diagnostic.jump = original_jump
  assert(ok, err)
end)
