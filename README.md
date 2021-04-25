# snap

*Placeholder plugin for vim done right*

![animated image showing placeholder selection][placeholder_gif]

**Important**: If you want the dot operator (repeating) to work, you need to
also install [vim-repeat](https://github.com/tpope/vim-repeat/)!

See `:help snap.txt` in vim for detailed help.

## Example Configuration

No bindings are enabled by default, but below are the recommended mappings (that
I use). You can see the bindings at work in the above animated gif.

| Key Binding                  | Action                              |
|:-----------------------------|:------------------------------------|
| <kbd>Meta</kbd>+<kbd>;</kbd> | insert a placeholder                |
| <kbd>Meta</kbd>+<kbd>:</kbd> | insert a reminder                   |
| <kbd>Meta</kbd>+<kbd>l</kbd> | snap to next placeholder            |
| <kbd>Meta</kbd>+<kbd>L</kbd> | repeat snap on next placeholder     |
| <kbd>Meta</kbd>+<kbd>h</kbd> | snap to previous placeholder        |
| <kbd>Meta</kbd>+<kbd>H</kbd> | repeat snap on previous placeholder |

I achieve that with the following configuration:

```vim
" insert placeholder
imap <m-;> <plug>(snapSimple)
" insert reminder
imap <m-:> <plug>(snapText)

" snap to next placeholder
imap <m-l> <plug>(snapNext)
nmap <m-l> <plug>(snapNext)
xmap <m-l> <plug>(snapNext)
smap <m-l> <plug>(snapNext)
omap <m-l> <plug>(snapNext)

" repeat last snap on next placeholder
imap <m-L> <plug>(snapRepeatNext)
nmap <m-L> <plug>(snapRepeatNext)
xmap <m-L> <plug>(snapRepeatNext)
smap <m-L> <plug>(snapRepeatNext)

" snap to previous placeholder
imap <m-h> <plug>(snapPrev)
nmap <m-h> <plug>(snapPrev)
xmap <m-h> <plug>(snapPrev)
smap <m-h> <plug>(snapPrev)
omap <m-h> <plug>(snapPrev)

" repeat last snap on previous placeholder
imap <m-H> <plug>(snapRepeatPrev)
nmap <m-H> <plug>(snapRepeatPrev)
xmap <m-H> <plug>(snapRepeatPrev)
smap <m-H> <plug>(snapRepeatPrev)
```

There are so many `<plug>` mappings so you can pick whichever bindings you want
and don't have to use whatever bindings I hard-code. Flexibility is important.

### Meta Keys in Vim

Vim cannot bind meta keys properly out of the box. However, you can force vim to
bind meta keys properly by sticking this near the top of your vimrc:

```vim
" set up Meta to work properly for most keys in terminal vim
if !has('nvim') && !has('gui_running')
  " PROBLEMS: not possible to map Meta with Arrow Keys or Tab (etc)
  " PROBLEMS: 32 (space), 62 (>), 91 ([), 93 (])
  for ord in range(33,61)+range(63,90)+[92]+range(94,126)
    let char = ord is 34 ? '\"' : ord is 124 ? '\|' : nr2char(ord)
    exec printf("set <m-%s>=\<esc>%s", char, char)
    if exists(':tnoremap') " fix terminal control sequences
      exec printf("tnoremap <silent> <m-%s> <esc>%s", char, char)
    endif
  endfor
  " PROBLEMS: <c-up>,<c-down> do not work in any terminal
  " set up <c-left> and <c-right> properly
  exe "set <c-right>=\<esc>[1;5C"
  exe "set <c-left>=\<esc>[1;5D"
  " NOTE: if above don't work, compare with ctrl-v + CTRL-{LEFT,RIGHT} in INSERT mode
endif
" NOTE: use "map <m-\|>" or "map <m-bar>" to map <bar> (|)
```

Be sure to test to make sure this works. For example, try `:nnoremap <m-h> :echo
'Hello world!'<cr>` then type <kbd>Meta</kbd>+<kbd>h</kbd>.

## Options

### Snap Text

The placeholder text is fully customizable. See `:help g:snap#text`.

For example, you can make it look like `«⋄»` and `«⋄→reminder»` with the
following configuration:

```vim
let g:snap#text = ['«⋄', '→', '»']
```

### Snap Select

If you want the reminder text to be inserted and then selected in Select-mode
when snapping to a reminder (see `:help g:snap#select`), then use the following:

```vim
let g:snap#select = 1
```

[placeholder_gif]:https://raw.githubusercontent.com/novasenco/i/master/placeholder.gif

