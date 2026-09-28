#include <iostream>
#include <string>
#include <utility>
#include <vector>
class Greeter{
public:
explicit Greeter(std::string prefix):prefix_(std::move(prefix)){}
std::string greet(const std::string& name) const{return prefix_+", "+name+"!";}
private:
std::string prefix_;
};
int main(){
Greeter g("Hello");
std::vector<std::string> names={"Ada","Linus","Grace"};
for(const auto& n:names){std::cout<<g.greet(n)<<"\n";}
int unused=0;
return 0;}
