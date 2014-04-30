"==============================================================================
"Script Title: rainbow parentheses improved
"Script Version: 3.1.3
"Author: luochen1990
"Last Edited: 2014 April 30
"Simple Configuration:
"	first, put "rainbow.vim"(this file) to dir vimfiles/plugin or vim73/plugin
"	second, add the follow sentences to your .vimrc or _vimrc :
"	 	let g:rainbow_active = 1
"	third, restart your vim and enjoy coding.
"Advanced Configuration:
"	an advanced configuration allows you to define what parentheses to use 
"	for each type of file . you can also determine the colors of your 
"	parentheses by this way (read file vim73/rgb.txt for all named colors).
"	READ THE SOURCE FILE FROM LINE 25 TO LINE 50 FOR EXAMPLE.
"User Command:
"	:RainbowToggle		--you can use it to toggle this plugin.
"==============================================================================

if exists('s:loaded') || !(exists('g:rainbow_active') || exists('g:rainbow_conf'))
	finish
endif
let s:loaded = 1
 
let s:rainbow_conf = {
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
\		'xml': {
\			'parentheses': [['(',')'], ['\[','\]'], ['{','}'], ['<\a[^>]*[^/]>\|<\a>','</[^>]*>']],
\		},
\		'html': {
\			'parentheses': [['(',')'], ['\[','\]'], ['{','}'], ['<\a[^>]*[^/]>\|<\a>','</[^>]*>']],
\		},
\		'vim': {
\			'parentheses': [['fu\w* \s*.*)','endfu\w*'], ['for','endfor'], ['while', 'endwhile'], ['if','_elseif\|else_','endif'], ['(',')'], ['\[','\]'], ['{','}']],
\		},
\		'tex': {
\			'parentheses': [['(',')'], ['\[','\]'], ['\\begin{.*}','\\end{.*}']],
\		},
\	}
\}

func rainbow#load()
	let conf = deepcopy(b:rainbow_conf)
	let maxlvl = has('gui_running')? len(conf.guifgs) : len(conf.ctermfgs)
	for i in range(len(conf.parentheses))
		let p = conf.parentheses[i]
		let op = len(p)==3? p[1] : has_key(conf, 'operators')? conf.operators : ''
		let conf.parentheses[i] = [p[0], op, p[-1]]
	endfor
	let str = 'TOP'
	for each in range(1, maxlvl)
		let str .= ',lv'.each
	endfor
	let cmd = 'syn region %s matchgroup=%s start=+%s+ end=+%s+ containedin=%s contains=%s fold'
	let cmd2 = 'syn match %s %s containedin=%s contained'
	call rainbow#clear()
	let b:rainbow_loaded = maxlvl
	for [left, mid, right] in conf.parentheses
		for each in range(1, maxlvl - 1)
			if mid != ''
				exe printf(cmd2, 'op_lv'.each, mid, 'lv'.each)
			endif
			exe printf(cmd, 'lv'.each, 'lv'.each.'c', left, right, 'lv'.(each+1), str.',op_lv'.each)
		endfor
		if mid != ''
			exe printf(cmd2, 'op_lv'.maxlvl, mid, 'lv'.maxlvl)
		endif
		exe printf(cmd, 'lv'.maxlvl, 'lv'.maxlvl.'c', left, right, 'lv1', str.',op_lv'.maxlvl)
	endfor
	call rainbow#show()
endfunc

func rainbow#clear()
	call rainbow#hide()
	if exists('b:rainbow_loaded')
		for each in range(1 , b:rainbow_loaded)
			exe 'syn clear lv'.each
			exe 'syn clear op_lv'.each
		endfor
		unlet b:rainbow_loaded
	endif
endfunc

func rainbow#show()
	if exists('b:rainbow_loaded')
		let b:rainbow_visible = 1
		for id in range(1 , b:rainbow_loaded)
			let ctermfg = b:rainbow_conf.ctermfgs[(b:rainbow_loaded - id) % len(b:rainbow_conf.ctermfgs)]
			let guifg = b:rainbow_conf.guifgs[(b:rainbow_loaded - id) % len(b:rainbow_conf.guifgs)]
			exe 'hi default lv'.id.'c ctermfg='.ctermfg.' guifg='.guifg
			exe 'hi default op_lv'.id.' ctermfg='.ctermfg.' guifg='.guifg
		endfor
	endif
endfunc

func rainbow#hide()
	if exists('b:rainbow_visible')
		for each in range(1, b:rainbow_loaded)
			exe 'hi clear lv'.each.'c'
			exe 'hi clear op_lv'.each.''
		endfor
		unlet b:rainbow_visible
	endif
endfunc

func rainbow#toggle()
	if exists('b:rainbow_loaded')
		call rainbow#clear()
	else
		if exists('b:rainbow_conf')
			call rainbow#load()
		else
			call rainbow#hook()
		endif
	endif
endfunc

func rainbow#hook()
	let g_conf = extend(copy(s:rainbow_conf), exists('g:rainbow_conf')? g:rainbow_conf : {}) |unlet g_conf.separately
	let separately = extend(copy(s:rainbow_conf.separately), exists('g:rainbow_conf.separately')? g:rainbow_conf.separately : {})
	let b_conf = has_key(separately, &ft)? separately[&ft] : separately['*']
	if type(b_conf)==type({})
		let b:rainbow_conf = extend(g_conf, b_conf)
		call rainbow#load()
	endif
endfunc

command! RainbowToggle call rainbow#toggle()

if (exists('g:rainbow_active') && g:rainbow_active)
	auto syntax * call rainbow#hook()
	auto colorscheme * call rainbow#show()
endif
