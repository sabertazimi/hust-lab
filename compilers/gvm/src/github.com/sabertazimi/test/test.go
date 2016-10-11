//
// test.go
// Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
//
// Distributed under terms of the MIT license.
//

package main

import (
    "fmt"
    "github.com/sabertazimi/stringutils"
)

func swap(x, y string) (string, string) {
    return y, x
}

func swap_(x, y string) (x_, y_ string) {
    x_, y_ = y, x
    return
}

func main() {
    a, b := swap("Hello", "Golang!")
    a_, b_ := swap_("Hello", "Golang!")
    fmt.Println(b, a)
    fmt.Println(b_, a_)
	fmt.Printf(stringutils.Reverse("\n!gnaloG olleH"))
}
