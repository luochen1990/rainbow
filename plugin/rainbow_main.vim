if exists('s:loaded') || !(exists('g:rainbow_active') || exists('g:rainbow_conf')) | finish | endif | let s:loaded = 1

let s:rainbow_conf = {
\	'syn_name_prefix': 'rainbow',
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'tex': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'vim': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\		},
\		'xml': {
\			'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
\		},
\		'xhtml': {
\			'parentheses': ['start=/\v\<\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'))?)*\>/ end=#</\z1># fold'],
\		},
\		'html': {
\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\		},
\		'perl': {
\			'syn_name_prefix': 'perlBlockFoldRainbow',
\		},
\		'php': {
\			'syn_name_prefix': 'phpBlockRainbow',
\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold', 'start=/(/ end=/)/ containedin=@htmlPreproc contains=@phpClTop', 'start=/\[/ end=/\]/ containedin=@htmlPreproc contains=@phpClTop', 'start=/{/ end=/}/ containedin=@htmlPreproc contains=@phpClTop'],
\		},
\		'css': 0,
\		'sh': {
\			'parentheses': [['\(^\|\s\)\S*()\s*{\?\($\|\s\)','_^{_','}'], ['\(^\|\s\)if\($\|\s\)','_\(^\|\s\)\(then\|else\|elif\)\($\|\s\)_','\(^\|\s\)fi\($\|\s\)'], ['\(^\|\s\)for\($\|\s\)','_\(^\|\s\)\(do\|in\)\($\|\s\)_','\(^\|\s\)done\($\|\s\)'], ['\(^\|\s\)while\($\|\s\)','_\(^\|\s\)\(do\)\($\|\s\)_','\(^\|\s\)done\($\|\s\)'], ['\(^\|\s\)case\($\|\s\)','_\(^\|\s\)\(\S*)\|in\|;;\)\($\|\s\)_','\(^\|\s\)esac\($\|\s\)']],
\			'after': ['syn clear shCondError'],
\		},
\	}
\}

fun s:eq(x, y)
	return type(a:x) == type(a:y) && a:x == a:y
endfun

fun rainbow_main#config()
	let g = exists('g:rainbow_conf')? g:rainbow_conf : {}
	"echom 'g:rainbow_conf:' string(g)
	let s = get(g, 'separately', {})
	"echom 'g:rainbow_conf.separately:' string(s)
	let dft_conf = extend(copy(s:rainbow_conf), g) | unlet dft_conf.separately
	"echom 'default config options:' string(dft_conf)
	let dx_conf = s:rainbow_conf.separately['*']
	"echom 'default star config:' string(dx_conf)
	let ds_conf = get(s:rainbow_conf.separately, &ft, dx_conf)
	"echom 'default separately config:' string(ds_conf)
	let ux_conf = get(s, '*', ds_conf)
	"echom 'user star config:' string(ux_conf)
	let us_conf = get(s, &ft, ux_conf)
	"echom 'user separately config:' string(us_conf)
	let conf = (s:eq(us_conf, 'default') ? ds_conf : us_conf)
	"echom 'almost finally config:' string(conf)
	return s:eq(conf, 0) ? 0 : extend(dft_conf, conf)
endfun

fun rainbow_main#load()
	if !exists('b:rainbow_conf') | let b:rainbow_conf = rainbow_main#config() | endif
	if type(b:rainbow_conf) != type({}) | return | endif
	call rainbow#syn(b:rainbow_conf)
	call rainbow#hi(b:rainbow_conf)
	let b:rainbow_loaded = 1
endfun

fun rainbow_main#clear()
	call rainbow#hi_clear(b:rainbow_conf)
	call rainbow#syn_clear(b:rainbow_conf)
	let b:rainbow_loaded = 0
endfun

fun rainbow_main#toggle()
	if exists('b:rainbow_loaded') && b:rainbow_loaded == 1
		call rainbow_main#clear()
	else
		call rainbow_main#load()
	endif
endfun

command! RainbowToggle call rainbow_main#toggle()
command! RainbowToggleOn call rainbow_main#load()
command! RainbowToggleOff call rainbow_main#clear()

if (exists('g:rainbow_active') && g:rainbow_active)
	auto syntax * call rainbow_main#load()
	auto colorscheme * call rainbow_main#load()
endif
