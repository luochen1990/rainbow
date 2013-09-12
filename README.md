#Rainbow Parentheses Improved

This is a fork of [Rainbow Parentheses Improved](http://www.vim.org/scripts/script.php?script_id=4176) by [luo chen](http://www.vim.org/account/profile.php?user_id=53618).

I've applied some minor corrections and modifications:

* Operators outside any braces get the last color of the rainbow. Previously, it was being ignored for highlighting.
* Simplified/corrected logic to define highlighting precedence for braces as higher than for operators. So if you got a brace that's also an operator and you got to the situation that it can match both roles, it'll assume the brace role.
* Changed default highlighted operators (now most punctuation) and highlighted braces (added `<` and `>` for C++).
* Removed optional highlighting for operators. Now hard enabled.
* Changed loading autocommand for the events "syntax" and "colorscheme" so that the rainbow gets loaded only when there's syntax being applied and aways after switching colorschemes.
* Changed default colors. Default rainbow colors copied from [gruvbox colorscheme](https://github.com/morhetz/gruvbox) (good for dark and light backgrounds).

Angle brackets are a hard case to deal with. To distinguish "less than" from "bracket for open template argument list" it's assumed that "less than" will always be surrounded by spaces. If not, it'll be treated as an open template's angle bracket (although, still some checking applies for the `template` or `operator` keyword, for example).

This fork is optimized for C++ highlighting.

###Simple Configuration

Put this on your `.vimrc` for loading it for specific file types:

```vim
au FileType c,cpp,objc,objcpp call rainbow#load()
```
or just this to enable it globally:

```vim
let g:rainbow_active = 1
```

###Advanced Configuration
An advanced configuration allows you to define what parentheses to use
for each type of file. You can also determine the colors of your
parentheses by this way (read file vim73/rgb.txt for all named colors).

e.g. this is an advanced config (add these sentences to your `.vimrc`):

```vim
let g:rainbow_active = 1

let g:rainbow_load_separately = [
    \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
    \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
    \ ]

let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']
```

###User Command
```
:RainbowToggle  --you can use it to toggle this plugin.
:RainbowLoad    --you can use it to load/reload this plugin.
```
I recommend [VAM](https://github.com/MarcWeber/vim-addon-manager) or [Vundle](https://github.com/gmarik/vundle) for plugin management.

Here's a sample of a dark [gruvbox](https://github.com/morhetz/gruvbox) vim session:

<a href="http://i.imgur.com/pcCkFxf.png">![Dark VIM Session](http://i.imgur.com/pcCkFxf.png)</a>

and here's a light [newspaper](https://github.com/flazz/vim-colorschemes/blob/master/colors/newspaper.vim) session:

<a href="http://i.imgur.com/CxTulnu.png">![Light VIM Session](http://i.imgur.com/CxTulnu.png)</a>

I thank Luo for being supportive and accepting the operator highlighting idea.
