// Package greeter builds greeting messages.
package greeter

import "fmt"

// Greet returns a greeting for name.
func Greet(name string) string {
	return fmt.Sprintf("Hello, %s!", name)
}
