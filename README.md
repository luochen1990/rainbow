Rainbow Parentheses Improved 
===
>	help you read complex code by showing diff level of parentheses in diff color !! 

description [(这里有中文版)](https://github.com/luochen1990/rainbow/blob/ori/README_zh.md)
-------------------------------------------------------------------------------------------------------- 

As everyone knows, the most complex codes were composed of a mass of different kinds of parentheses. 
This plugin will help you read these codes by showing different levels of parentheses in different colors. 
**See the effect [here](http://vim.wikia.com/wiki/Script:4176)**.
you can also find this plugin in **www.vim.org [here](http://www.vim.org/scripts/script.php?script_id=4176)**.

What is improved ? 
-------------------------------------------------------------------------------------------------------- 

- separately edit guifgs and ctermfgs (the colors used to highlight) 

- now you can design your own parentheses  such as 'begin' and 'end' . (you can also design  what kinds of parentheses to use for different filetypes. ) 

- now you can even decide to let some operators (like + - * / , ==) hilighted with the parentheses together, you can also decide this seprately for different type of files. 

- no limit of parentheses levels. 

- smoother and faster. (linear time complexity) 

- the code is shorter and easier to be read now. (shorter than 100 lines) 

- the last , but not the least , the chinese statement is added as you see. 

Get Old Versions: 
-------------------------------------------------------------------------------------------------------- 
- http://www.vim.org/scripts/script.php?script_id=1561 
- http://www.vim.org/scripts/script.php?script_id=3772 

Old Versions' Author: 
-------------------------------------------------------------------------------------------------------- 
- Martin Krischik (krischik@users.sourceforge.net) 
- John Gilmore 
- Luc Hermitte (hermitte@free.fr) 
- anonym 

This Versions' Author: 
-------------------------------------------------------------------------------------------------------- 
- Luo Chen (luochen1990@gmail.com) 

install details
-------------------------------------------------------------------------------------------------------- 

- First, put the rainbow.vim to dir vim73/plugin or vimfiles/plugin (if exists one, the latter is recommended) 

- Second, add the follow sentences to your`.vimrc`or`_vimrc` : 
	```
	let g:rainbow_active = 1 
	let g:rainbow_operators = 1 
	```
- Third, restart your vim and enjoy coding. 

>	Read the source file for Advanced Configuration. 

**Rate this script if you like it, 
and i'll appreciate it and improve this plugin for you because of your support ! 
just goto [this page](http://www.vim.org/scripts/script.php?script_id=4176) and choose `Life Changing` and click `rate`**
 
