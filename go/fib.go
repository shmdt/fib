package main

import "C"

//export fib
func fib(n C.uint) C.uint {
	if n <= 1 {
		return n
	} else {
		return fib(n-1) + fib(n-2)	
	}
}

func main() {
// This is necessary for the compiler.
// You can add something that will be executed when engaging your library to the interpreter.
}