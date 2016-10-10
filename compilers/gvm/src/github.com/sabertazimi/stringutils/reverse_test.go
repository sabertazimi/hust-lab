//
// reverse_test.go
// Copyright (C) 2016 sabertazimi <sabertazimi@gmail.com>
//
// Distributed under terms of the MIT license.
//

package stringutils

import "testing"

func TestReverse(t *testing.T) {
	cases := []struct {
		in, want string
	}{
		{"Hello, world", "dlrow ,olleH"},
		{"Hello, 世界", "界世 ,olleH"},
		{"", ""},
	}

	for _, c := range cases {
		got := Reverse(c.in)

		if got != c.want {
			t.Errorf("Reveres(%q) == %q, want %q", c.in, got, c.want)
        }
    }
}
