#Rainbow Parentheses Improved

This is a fork of [Rainbow Parentheses Improved](http://www.vim.org/scripts/script.php?script_id=4176) by [luo chen](http://www.vim.org/account/profile.php?user_id=53618).

I've applied some minor corrections and modifications to it:

* Operators outside any braces get the last color of the rainbow. Previously, it was being ignored for highlighting.
* Simplified/corrected logic to define highlighting precedence for braces as higher than for operators. So if you got a brace that's also an operator and you got to the situation that it can match both roles, it'll assume the brace role.
* Changed default colors. Seems good to test with the [mustang colorscheme](https://github.com/flazz/vim-colorschemes/blob/master/colors/mustang.vim).
* Changed default highlighted operators (now most punctuation) and highlighted braces (added `<` and `>`).
* Removed optional highlighting for operators. Now hard enabled.

Angle brackets are a hard case to deal with. To distinguish "less than" from "bracket for open template argument list" it's assumed that "less than" will always be surrounded by spaces. If not, it'll be treated as an open template's angle bracket (although, still some checking applies for the `template` or `operator` keyword, for example).

This fork is optimized for C++ highlighting in dark colorschemes by default.

Put this on your `.vimrc`:

```vim
au FileType c,cpp,objc,objcpp call rainbow#load()
```
This is in case one wants to customize the colors of the rainbow:

```vim
" rainbow colors copied from and best suited for dark gruvbox colorscheme (https://github.com/morhetz/gruvbox):
let g:rainbow_guifgs = [
    \ '#458588',
    \ '#b16286',
    \ '#cc241d',
    \ '#d65d0e',
    \ '#458588',
    \ '#b16286',
    \ '#cc241d',
    \ '#d65d0e',
    \ '#458588',
    \ '#b16286',
    \ '#cc241d',
    \ '#d65d0e',
    \ '#458588',
    \ '#b16286',
    \ '#cc241d',
    \ '#d65d0e',
    \ ]
au FileType c,cpp,objc,objcpp call rainbow#load()
```

I recommend [VAM](https://github.com/MarcWeber/vim-addon-manager) or [Vundle](https://github.com/gmarik/vundle) for plugin management.

Here's a sample of one vim session:

<a href="http://i.imgur.com/pcCkFxf.png">![VIM Session](http://i.imgur.com/pcCkFxf.png)</a>

I thank Luo for being supportive and accepting the operator highlighting idea.
