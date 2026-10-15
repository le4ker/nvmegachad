vim.opt.rtp:prepend(vim.fn.getcwd())
package.path = "./lua/?.lua;./lua/?/init.lua;./tests/?.lua;" .. package.path

local filter = vim.env.SPEC
for _, path in ipairs(vim.fn.glob("tests/**/*_spec.lua", false, true)) do
  local module = path:gsub("^tests/", ""):gsub("%.lua$", ""):gsub("/", ".")
  if not filter or path:find(filter, 1, true) or module:find(filter, 1, true) then
    require(module)
  end
end

require("test_helper").run()
