local T = require("test_helper")

T.test("options set the expected Neovim defaults and format-on-save toggle", function()
  local saved = {
    backup = vim.opt.backup:get(),
    swapfile = vim.opt.swapfile:get(),
    undofile = vim.opt.undofile:get(),
    colorcolumn = vim.opt.colorcolumn:get(),
    relativenumber = vim.opt.relativenumber:get(),
    list = vim.opt.list:get(),
    listchars = vim.opt.listchars:get(),
    completeopt = vim.opt.completeopt:get(),
  }
  T.cleanup(function()
    for name, value in pairs(saved) do
      vim.opt[name] = value
    end
  end)
  T.stub(vim.g, "format_on_save", vim.g.format_on_save)
  T.with_modules({ ["nvchad.options"] = true }, function()
    dofile("lua/options.lua")
  end)
  T.eq(vim.g.format_on_save, true)
  T.eq(tostring(vim.opt.backup:get()), "false")
  T.eq(tostring(vim.opt.swapfile:get()), "false")
  T.eq(tostring(vim.opt.undofile:get()), "true")
  T.eq(vim.opt.colorcolumn:get()[1], "100")
  T.eq(vim.opt.relativenumber:get(), true)
  T.eq(vim.opt.list:get(), true)
  T.eq(vim.opt.listchars:get().tab, "➝ ")
  T.eq(vim.opt.listchars:get().space, "·")
  T.eq(table.concat(vim.opt.completeopt:get(), ","), "menuone,noselect,popup")
end)

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

T.test("treesitter installs parsers and starts highlighting on FileType", function()
  local setup_opts, installed, autocmd, started
  T.with_modules({
    ["nvim-treesitter"] = {
      setup = function(opts)
        setup_opts = opts
      end,
      install = function(parsers)
        installed = parsers
      end,
    },
  }, function()
    T.stub(vim.api, "nvim_create_autocmd", function(event, opts)
      autocmd = { event, opts }
    end)
    T.stub(vim.treesitter, "start", function(buf, lang)
      started = { buf, lang }
    end)
    require("configs.plugins.treesitter").setup()
  end)
  T.eq(type(setup_opts), "table")
  T.eq(type(installed), "table")
  assert(#installed > 0, "Tree-sitter parser list is empty")
  local seen = {}
  for _, parser in ipairs(installed) do
    assert(not seen[parser], "duplicate Tree-sitter parser: " .. parser)
    seen[parser] = true
  end
  T.eq(autocmd[1], "FileType")
  autocmd[2].callback({ buf = 17, match = "lua" })
  T.eq(table.concat(started, ","), "17,lua")
end)

T.test("VimEnter opens the tree without focus only when it is hidden", function()
  local autocmd, visible, toggles = nil, false, {}
  T.stub(vim.api, "nvim_create_autocmd", function(event, opts)
    T.eq(event, "VimEnter")
    autocmd = opts
  end)
  T.with_modules({
    ["nvchad.autocmds"] = true,
    ["nvim-tree.api"] = {
      tree = {
        is_visible = function()
          return visible
        end,
        toggle = function(opts)
          toggles[#toggles + 1] = opts
        end,
      },
    },
  }, function()
    dofile("lua/autocmds.lua")
    autocmd.callback()
    T.eq(toggles[1].focus, false)
    visible = true
    autocmd.callback()
    T.eq(#toggles, 1)
  end)
end)
