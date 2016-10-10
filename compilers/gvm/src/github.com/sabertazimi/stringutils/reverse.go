//
// reverse.go
// Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
//
// Distributed under terms of the MIT license.
//

package stringutils

func Reverse(s string) string {
	r := []rune(s)

	for i, j := 0, len(r)-1; i < len(r)/2; i, j = i+1, j-1 {
		r[i], r[j] = r[j], r[i]
	}

	return string(r)
}
