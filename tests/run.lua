vim.opt.rtp:prepend(vim.fn.getcwd())
package.path = "./lua/?.lua;./lua/?/init.lua;./tests/?.lua;" .. package.path

for _, path in ipairs(vim.fn.glob("tests/**/*_spec.lua", false, true)) do
  local module = path:gsub("^tests/", ""):gsub("%.lua$", ""):gsub("/", ".")
  require(module)
end

require("test_helper").run()
