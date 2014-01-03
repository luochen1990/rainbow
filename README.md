Rainbow Parentheses Improved 
===
>	help you read complex code by showing diff level of parentheses in diff color !! 

Description [(这里有中文版)](https://github.com/luochen1990/rainbow/blob/master/README_zh.md)
-------------------------------------------------------------------------------------------------------- 

As everyone knows, the most complex codes were composed of a mass of different kinds of parentheses(typically: lisp). 
This plugin will help you read these codes by showing different levels of parentheses in different colors. 
**See the effect [here](http://vim.wikia.com/wiki/Script:4176)**.
you can also find this plugin in **www.vim.org [here](http://www.vim.org/scripts/script.php?script_id=4176)**.

#### lisp
![lisp](https://raw.github.com/luochen1990/rainbow/master/demo/lisp.png)
#### html
![html](https://raw.github.com/luochen1990/rainbow/master/demo/html.png)
#### [more](https://github.com/luochen1990/rainbow/blob/master/demo/more.md)

### What is improved ? 

- smoother and faster. (linear time complexity) 
- the code is shorter and easier to be read now. (shorter than 100 lines) 
- no limit of parentheses levels. 
- separately edit guifgs and ctermfgs (the colors used to highlight) 
- now you can design your own parentheses  such as 'begin' and 'end' . (you can also design  what kinds of parentheses to use for different filetypes. ) 
- you can also configure seprately for different type of files. 
- now you can even decide to let some operators (like + - * / , ==) hilighted with the parentheses together.
- now json style configuration used, more understandable and more readable, easily for advanced configuration.
- the last , but not the least , the chinese statement is added as you see. 

### Get Old Versions: 
- http://www.vim.org/scripts/script.php?script_id=1561 
- http://www.vim.org/scripts/script.php?script_id=3772 

### Old Versions' Author: 
- Martin Krischik (krischik@users.sourceforge.net) 
- John Gilmore 
- Luc Hermitte (hermitte@free.fr) 
- anonym 

### This Versions' Author: 
- Luo Chen (luochen1990@gmail.com) 

Install & Simple Configuration:
-------------------------------------------------------------------------------------------------------- 

### Install by Bundle:
- `Bundle 'luochen1990/rainbow'`
- 在vimrc加入 `let g:rainbow_active = 1` (顺序不重要)

### manually:
- first, put `rainbow.vim`(this file) to dir `vimfiles/plugin` or `~/.vim/plugin`
- second, add the follow sentences to your `.vimrc` or `_vimrc` :
	```vim
	let g:rainbow_active = 1
	```
- third, restart your vim and enjoy coding.

Advanced Configuration：
-------------------------------------------------------------------------------------------------------- 

- there is an example for advanced configuration(also default one), add it to your vimrc and edit it as you wish(just keep the format).

	```vim
	let g:rainbow_conf = {
	\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
	\	'ctermfgs': ['darkgray', 'darkblue', 'darkmagenta', 'darkcyan'],
	\	'operators': '_,_',
	\	'parentheses': [['(',')'], ['\[','\]'], ['{','}']],
	\	'separately': {
	\		'*': {},
	\		'lisp': {
	\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	\			'ctermfgs': ['darkgray', 'darkblue', 'darkmagenta', 'darkcyan', 'darkred', 'darkgreen'],
	\		},
	\		'html': {
	\			'parentheses': [['(',')'], ['\[','\]'], ['{','}'], ['<\a[^>]*[^/]>\|<\a>','</[^>]*>']],
	\		},
	\		'tex': {
	\			'operators': '',
	\			'parentheses': [['(',')'], ['\[','\]']],
	\		},
	\	}
	\}
	```

- 'guifgs': colors for gui interface, will be used in order.
- 'ctermfgs': colors for terms
- 'operators': describe the operators you want to highlight(read the vim help :syn-pattern)
- 'parentheses': describe what will be processed as parentheses, a pair of parentheses was described by two re pattern
- 'separately': configure for specific filetypes(decided by &ft), '\*' for filetypes without configuration


User Command:
-------------------------------------------------------------------------------------------------------- 

- **:RainbowToggle**		--you can use it to toggle this plugin.

-------------------------------------------------------------------------------------------------------- 
**Rate this script if you like it, 
and i'll appreciate it and improve this plugin for you because of your support ! 
just goto [this page](http://www.vim.org/scripts/script.php?script_id=4176) and choose `Life Changing` and click `rate`**
 
