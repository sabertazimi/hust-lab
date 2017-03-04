# A simple in memory file system

hold all datas in js objects

[![author](https://img.shields.io/badge/author-sabertazimi-lightgrey.svg)](https://github.com/sabertazimi)
[![stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/sabertazimi/hust-os-2017)
[![mit](https://img.shields.io/badge/license-mit-brightgreen.svg)](https://raw.githubusercontent.com/sabertazimi/hust-os-2017/master/LICENSE)

## Directory

```js
// dir
dir[''] === true
// { '': true }
```

```js
// sub dir
dir[subdir][''] === true
// { '': true, subdir: {'' : true} }
```

## File

```js
// file
!dir['']
/* /a/b/c/imfs.js => */
/* { */
/*     "": true, */
/*     "a": { */
/*         "": true, */
/*         "b": { */
/*             "": true, */
/*             "c": { */
/*                 "":true, */
/*                 "imfs.js": content */
/*             } */
/*         } */
/*     } */
/* } */
```

## Robust

use Error and try/catch to handle exception

## License

[mit license](https://raw.githubusercontent.com/sabertazimi/hust-os-2017/master/LICENSE) @[sabertazimi](https://github.com/sabertazimi)

## Contact

*   [![Email](https://img.shields.io/badge/mailto-sabertazimi-brightgreen.svg?style=flat-square)](mailto:sabertazimi@gmail.com)
*   [![GitHub](https://img.shields.io/badge/contact-github-000000.svg?style=flat-square)](https://github.com/sabertazimi)
*   [![Twitter](https://img.shields.io/badge/contact-twitter-blue.svg?style=flat-square)](https://twitter.com/sabertazimi)
 
