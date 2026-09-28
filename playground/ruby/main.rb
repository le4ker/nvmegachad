require_relative "lib/greeter"

names = ["Ada", 'Linus', "Grace"]
unused = 1
names.each do |name|
puts Greeter.greet( name )
end
