#Rainbow Parentheses Improved

This is a fork of [Rainbow Parentheses Improved](http://www.vim.org/scripts/script.php?script_id=4176) by [luo chen](http://www.vim.org/account/profile.php?user_id=53618).

I've applied some minor corrections and modifications to it:

* Operators outside any braces get the last color of the rainbow. Previously, it was being ignored for highlighting.
* Simplified/corrected logic to define highlighting precedence for braces as higher than for operators. So if you got a brace that's also an operator and you got to the situation that it can match both roles, it'll assume the brace role.
* Changed default colors. Seems good to test with the [mustang colorscheme](https://github.com/flazz/vim-colorschemes/blob/master/colors/mustang.vim).
* Changed default highlighted operators (now most punctuation) and highlighted braces (added < and >).

Currently, check [this SO answer](http://stackoverflow.com/a/13633152/1000282) to know how angle brackets for templates are being distinguished from relational ones.

This fork is optimized for C++ highlighting by default.

Put this on your `.vimrc`:

```VimL
let g:rainbow_operators = 2 
au FileType c,cpp,objc,objcpp call rainbow#activate()
```

I recommend [VAM](https://github.com/MarcWeber/vim-addon-manager) or [Vundle](https://github.com/gmarik/vundle) for plugin management.

I thank Luo for being supportive and accepting the operator highlighting idea.
