Rainbow Parentheses Improved 
===
>	help you read complex code by showing diff level of parentheses in diff color !! 

Description [(这里有中文版)](https://github.com/luochen1990/rainbow/blob/master/README_zh.md)
---------------------------------------------------------------------------------------------------

As everyone knows, the most complex codes were composed of a mass of different kinds of parentheses (typically: lisp).
This plugin will help you read these codes by showing different levels of parentheses in different colors.
You can also find this plugin in **[www.vim.org](http://www.vim.org/scripts/script.php?script_id=4176)**.

#### lisp
![lisp](https://raw.githubusercontent.com/luochen1990/rainbow/demo/lisp.png)
#### html
![html](https://raw.githubusercontent.com/luochen1990/rainbow/demo/html.png)
#### [more](https://github.com/luochen1990/rainbow/blob/demo/more.md)

### What is improved ? 

- no limit of parentheses levels. 
- separately edit guifgs and ctermfgs (the colors used for highlighting).
- now you can design your own parentheses  such as 'begin' and 'end'.
- you can also configure anything separately for different types of files. 
- now you can even decide to let some operators (like + - * / , ==) highlighted with the parentheses together.
- json style configuration used, more understandable and readable, easier for advanced configuration.
- the code is shorter and easier to read now.
- smoother and faster.
- the Chinese document is added.

### Referenced: 
- http://www.vim.org/scripts/script.php?script_id=1561 (Martin Krischik)
- http://www.vim.org/scripts/script.php?script_id=3772 (kien)

Install:
--------

### via Vundle:

```vim
Plugin 'luochen1990/rainbow'
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
```

### Manually:
- first, put `rainbow.vim`(this file) to dir `~/.vim/plugin` or `vimfiles/plugin`
- second, add the follow sentences to your `.vimrc` or `_vimrc` :

	```vim
	let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
	```

- third, restart your vim and enjoy coding.

Configure:
----------

There is an example for advanced configuration (which I'm using), add it to your vimrc and edit it as you wish (just keep the format).

```vim
	let g:rainbow_conf = {
	\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
	\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	\	'operators': '_,_',
	\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\	'separately': {
	\		'*': {},
	\		'tex': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
	\		},
	\		'lisp': {
	\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	\		},
	\		'vim': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	\		},
	\		'html': {
	\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	\		},
	\		'css': 0,
	\	}
	\}
```

- 'guifgs': colors for gui interface, will be used in order.
- 'ctermfgs': colors for terms.
- 'operators': describe the operators you want to highlight (note: be careful about special characters which needs escaping, you can find more examples [here](https://github.com/luochen1990/rainbow/issues/3), and you can also read the [vim help about syn-pattern](http://vimdoc.sourceforge.net/htmldoc/syntax.html#:syn-pattern)).
- 'parentheses': describe what will be processed as parentheses, a pair of parentheses was described by two re pattern.
- 'separately': configure for specific filetypes (decided by &ft), key `*` for filetypes without separate configuration, value `0` means disable rainbow only for this type of files.
- keep a field empty to use the default setting.

User Command:
-------------

- **:RainbowToggle**		--you can use it to toggle this plugin.

------------------------------------------------------------------
**Rate this script if you like it, and I'll appreciate it and improve this plugin for you because of your support!

Just go to [this page](http://www.vim.org/scripts/script.php?script_id=4176) and choose `Life Changing` and click `rate`**
