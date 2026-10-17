local T = require("test_helper")

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
