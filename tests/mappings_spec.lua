local T = require("test_helper")

T.test("every configured keybinding has a description", function()
  local original_set = vim.keymap.set
  local original_mappings = package.loaded.mappings
  local maps = {}
  vim.keymap.set = function(mode, lhs, rhs, opts)
    maps[#maps + 1] = { mode = mode, lhs = lhs, rhs = rhs, opts = opts }
  end
  package.loaded.mappings = nil

  local ok, err = pcall(function()
    require("mappings")
    T.eq(#maps > 0, true)
    for _, mapping in ipairs(maps) do
      assert(type(mapping.opts) == "table", "mapping missing options: " .. mapping.lhs)
      assert(
        type(mapping.opts.desc) == "string" and mapping.opts.desc ~= "",
        "mapping missing desc: " .. mapping.lhs
      )
    end
  end)

  vim.keymap.set = original_set
  package.loaded.mappings = original_mappings
  assert(ok, err)
end)

T.test("Tab and Shift-Tab retain buffer and completion behavior", function()
  local original_set = vim.keymap.set
  local original_mappings = package.loaded.mappings
  local maps = {}
  vim.keymap.set = function(mode, lhs, rhs)
    maps[#maps + 1] = { mode = mode, lhs = lhs, rhs = rhs }
  end
  package.loaded.mappings = nil

  local ok, err = pcall(function()
    require("mappings")
    local blink = require("plugins.blink").opts.keymap
    T.eq(blink["<Tab>"][1], "select_next")
    T.eq(blink["<Tab>"][2], "snippet_forward")
    T.eq(blink["<S-Tab>"][1], "select_prev")
    T.eq(blink["<S-Tab>"][2], "snippet_backward")

    local next_buffer, previous_buffer = false, false
    for _, mapping in ipairs(maps) do
      next_buffer = next_buffer or (mapping.mode == "n" and mapping.lhs == "<tab>")
      previous_buffer = previous_buffer or (mapping.mode == "n" and mapping.lhs == "<S-tab>")
    end
    T.eq(next_buffer, true)
    T.eq(previous_buffer, true)
  end)

  vim.keymap.set = original_set
  package.loaded.mappings = original_mappings
  assert(ok, err)
end)
