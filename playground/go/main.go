package main

import (
"os"
"fmt"
	"example.com/playground/greeter"
)

func main() {
	os.Setenv("PLAYGROUND","1") // golangci-lint: errcheck
	names:=[]string{"Ada","Linus","Grace"}
	for i,name := range names {
		msg:=greeter.Greet(name)
			fmt.Println(i,msg) // DAP: set a breakpoint here
	}
}
