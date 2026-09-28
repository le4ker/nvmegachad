local greeter = require("lib.greeter")
local names = {"Ada","Linus","Grace"}
for i,name in ipairs(names) do
print(i,greeter.greet(name))
end
print(undefined_var) -- lua-language-server: undefined-global
