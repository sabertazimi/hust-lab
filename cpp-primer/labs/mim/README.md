# mim

[![Author](https://img.shields.io/badge/author-sabertaz-lightgrey?style=for-the-badge)](https://github.com/sabertazimi)
[![LICENSE](https://img.shields.io/github/license/sabertazimi/mim?style=for-the-badge)](https://raw.githubusercontent.com/sabertazimi/mim/master/LICENSE)

Minimal vim-like text editor

## Current Features

### Command Mode

*   `h/j/k/l`: move left/down/up/right
*   `0/$`: move to start/end of line
*   `^u / ^d`: page up/down
*   `G`: move to end of file
*   `i`: goto insert mode
*   `A/I/o/O`: more insert commands
*   `c/d`: delete char
*   `r`: replace char
*   `\b`: move left
*   `\r`: move down
*   `n/N`: jump to next/previous search point

### Insert Mode

*   `arrow` keys: move left/down/up/right
*   `home/end` keys: move to start/end of line
*   `page up/down` keys: page up/down
*   `esc` key: goto command mode
*   `^s`: save to file

### Lastline Mode

*   `:line_num`: jump to line
*   `:q`: quit
*   `:w`: save to file
*   `!`: force quit flag
*   `save as` file
*   `/`: search

### Status Bar

*   filename
*   total lines number
*   current line numebr

### Config

*   `tabs_width`: default 4
*   `set_num`: default on

## Future Features

*   more command/insert/lastline operations
*   complex command (e.g cl, dd)
*   undo/redo

## Key Terminology

### Change terminal mode

change mode of terminal from `canonical/cooked mode` (interact when 'enter' pressed)
to `raw mode` (interact immediately)

### Escape Sequences

*   `\x1b[` or `\033[` (`27[`) is the start of an escape sequence for terminal control command
*   Most termimal emulator support [VT100 terminal escape sequences](https://vt100.net/docs/vt100-ug/chapter3.html)

```c
\x1b[0J clear screen before cursor
\x1b[1J clear whole screen
\x1b[2J clear screen after cursor
\x1b[x;yH  move cursor to line x column y
```

## Resources

*   [ncurses library](http://www.ibiblio.org/pub/Linux/docs/HOWTO/other-formats/pdf/NCURSES-Programming-HOWTO.pdf)
*   [The Craft of Text Editing](https://www.finseth.com/craft/craft.pdf)
*   [VSCode Vim](https://github.com/VSCodeVim/Vim)
*   [Build Your Own Text Editor](https://viewsourcecode.org/snaptoken/kilo/index.html)
*   [Atom/VSCode](https://www.zhihu.com/question/272156541/answer/367784539)

## Contact

[![GitHub](https://img.shields.io/badge/-GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/sabertazimi)
[![Email](https://img.shields.io/badge/-Gmail-ea4335?style=for-the-badge&logo=gmail&logoColor=white)](mailto:sabertazimi@gmail.com)
[![X](https://img.shields.io/badge/-X.com-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/sabertazimi)
