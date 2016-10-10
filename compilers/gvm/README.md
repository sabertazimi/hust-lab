# GVM

```sh
  ______     ____  __
 / ___\ \   / /  \/  |
| |  _ \ \ / /| |\/| |
| |_| | \ V / | |  | |
 \____|  \_/  |_|  |_|

```

[![Author](https://img.shields.io/badge/author-sabertazimi-lightgrey.svg)](https://github.com/sabertazimi)
[![MIT](https://img.shields.io/badge/license-mit-brightgreen.svg)](https://raw.githubusercontent.com/sabertazimi/Awesome-Notes/master/LICENSE)

Go Virtual Machine - A toy Java virtual machine written in golang

## Go Basic Notes

### CLI

#### Build

```sh
# generate library
$ go build path/to/libpack
$ go install path/to/libpack

# generate binary
$ go install path/to/mainpack
```

#### Test

```sh
# path/to/pack/demo.go
# path/to/pack/demo_test.go
$ go test path/to/pack
```

#### Clean

```sh
$ go clean -i path/to/pack
```

#### Modules

*   remote packages

```sh
$ go get github.com/golang/example/hello
$ $GOPATH/bin/hello
```

### Packages

#### package and import

*   for path/to/pack:

```go
package pack
```

```go
import (
    "path/to/pack"
)
```

## TODO List

*   [] Merge golang notes into sabertazimi/awesome-notes/language/go/goBasicNotes.md

## License

MIT License Copyright (c) 2016 [sabertazimi](https://github.com/sabertazimi)

## Contact

-   [![Email](https://img.shields.io/badge/mailto-sabertazimi-brightgreen.svg?style=flat-square)](mailto:sabertazimi@gmail.com)
-   [![GitHub](https://img.shields.io/badge/contact-github-000000.svg?style=flat-square)](https://github.com/sabertazimi)
-   [![Twitter](https://img.shields.io/badge/contact-twitter-blue.svg?style=flat-square)](https://twitter.com/sabertazimi)

