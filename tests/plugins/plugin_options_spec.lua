local T = require("test_helper")

T.test("tree, gitsigns, codecompanion, telescope and Blink options are configured", function()
  local tree = require("plugins.tree")
  T.eq(tree.lazy, false)
  T.eq(tree.opts.filters.dotfiles, true)

  local gitsigns = require("plugins.gitsigns")
  T.eq(gitsigns.opts.current_line_blame, true)

  T.with_modules({
    ["codecompanion.adapters"] = {
      extend = function(name, opts)
        T.eq(name, "codex")
        return opts
      end,
    },
  }, function()
    local codecompanion = require("plugins.codecompanion")
    T.eq(codecompanion.opts.interactions.chat.adapter, "codex")
    T.eq(codecompanion.opts.interactions.chat.roles.user, "AI Agent - Codex")
    T.eq(codecompanion.opts.adapters.acp.codex().defaults.auth_method, "chat-gpt")
  end)

  local blink = require("plugins.blink").opts.keymap
  T.eq(table.concat(blink["<CR>"], ","), "accept,fallback")
  T.eq(table.concat(blink["<C-e>"], ","), "hide,fallback")

  local existing = { defaults = { layout_config = { width = 0.8 } } }
  local close = function() end
  T.with_modules({ ["telescope.actions"] = { close = close } }, function()
    local result = require("plugins.telescope").opts(nil, existing)
    T.eq(result.defaults.layout_config.width, 0.8)
    T.eq(result.defaults.mappings.i["<Esc><Esc>"], close)
    T.eq(result.defaults.mappings.n["<Esc><Esc>"], close)
  end)
end)
