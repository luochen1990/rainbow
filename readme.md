#Rainbow Parentheses Improved

This is a fork of [Rainbow Parentheses Improved](http://www.vim.org/scripts/script.php?script_id=4176) by [luo chen](http://www.vim.org/account/profile.php?user_id=53618).

I've applied some minor corrections and modifications to it:

* Operators outside any braces get the last color of the rainbow. Previously, it was being ignored for highlighting.
* Simplified/corrected logic to define highlighting precedence for braces as higher than for operators. So if you got a brace that's also an operator and you got to the situation that it can match both roles, it'll assume the brace role.
* Changed default colors. Seems good to test with the [mustang colorscheme](https://github.com/flazz/vim-colorschemes/blob/master/colors/mustang.vim).
* Changed default highlighted operators (now most punctuation) and highlighted braces (added `<` and `>`).

Angle brackets are a hard case to deal with. To distinguish "less than" from "open template argument list" it's assumed that "less than" will always be surrounded by spaces, if not, it will be treated as an open template angle bracket. Even if `<` is surrounded by spaces, there's still some elimination by checking keywords like `template`, `class` and `typename`.

This fork is optimized for C++ highlighting by default.

Put this on your `.vimrc`:

```VimL
let g:rainbow_operators = 2 
au FileType c,cpp,objc,objcpp call rainbow#activate()
```

I recommend [VAM](https://github.com/MarcWeber/vim-addon-manager) or [Vundle](https://github.com/gmarik/vundle) for plugin management.

I thank Luo for being supportive and accepting the operator highlighting idea.
