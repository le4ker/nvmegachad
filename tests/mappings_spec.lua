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
      for word in mapping.opts.desc:gmatch("%S+") do
        assert(word:match("^%u[%w]*$"), "invalid mapping description: " .. mapping.opts.desc)
      end
      assert(select(2, mapping.opts.desc:gsub(" ", " ")) >= 2, "incomplete mapping description")
    end
    local seen = {}
    for _, mapping in ipairs(maps) do
      for _, mode in ipairs(type(mapping.mode) == "table" and mapping.mode or { mapping.mode }) do
        local key = mode .. "\0" .. mapping.lhs
        assert(not seen[key], "duplicate mapping: " .. mode .. " " .. mapping.lhs)
        seen[key] = true
      end
    end
  end)

  vim.keymap.set = original_set
  package.loaded.mappings = original_mappings
  assert(ok, err)
end)

T.test("plugin commands used by mappings are declared or recognized", function()
  local maps, original_set, original = {}, vim.keymap.set, package.loaded.mappings
  vim.keymap.set = function(_, _, rhs)
    maps[#maps + 1] = rhs
  end
  package.loaded.mappings = nil
  local ok, err = pcall(function()
    require("mappings")
    local commands = {
      Lazy = { update = true },
      Telescope = {
        buffers = true,
        find_files = true,
        git_commits = true,
        git_status = true,
        live_grep = true,
        terms = true,
        themes = true,
      },
      NvimTreeFocus = true,
      NvimTreeToggle = true,
      MdKite = { toggle = true },
      NvCheatsheet = true,
      CodeCompanionChat = true,
      CodeCompanionActions = true,
    }
    for _, plugin in ipairs({ "dap", "codecompanion" }) do
      local spec = require("plugins." .. plugin)
      for _, command in ipairs(spec.cmd or {}) do
        commands[command] = true
      end
    end
    local core = { enew = true, noh = true, q = true, vsplit = true, w = true, y = true }
    for _, rhs in ipairs(maps) do
      if type(rhs) == "string" then
        local command, subcommand = rhs:match("<cmd>([%w]+)%s*([%w_]*)")
        if command and not core[command] then
          local allowed = commands[command]
          assert(allowed, "unrecognized mapped command: " .. command)
          if type(allowed) == "table" then
            assert(allowed[subcommand], "unrecognized " .. command .. " subcommand: " .. subcommand)
          end
        end
      end
    end
  end)
  vim.keymap.set, package.loaded.mappings = original_set, original
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
