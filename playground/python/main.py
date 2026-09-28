import sys
import os
from greeter import greet
from typing import List

def main()->None:
    names:List[str]=["Ada","Linus","Grace"]
    unused = 42
    for name in names:
        message=greet(name)
        print(message)  # DAP: set a breakpoint here
    count: int = "not an int"  # pyright: type error
    print(count)

if __name__=="__main__":
    main()
