if exists('s:loaded') | finish | endif | let s:loaded = 1

fun s:trim(s)
	return substitute(a:s, '\v^\s*(.{-})\s*$', '\1', '')
endfun

fun s:concat(strs)
	return join(filter(a:strs, "v:val !~ '^[ ]*$'"), ',')
endfun

fun s:resolve_parenthesis_with(init_state, p)
	let [paren, contained, containedin, contains, op] = a:init_state
	let p = (type(a:p) == type([])) ? ((len(a:p) == 3) ? printf('start=#%s# step=%s end=#%s#', a:p[0], op, a:p[-1]) : printf('start=#%s# end=#%s#', a:p[0], a:p[-1])) : a:p "NOTE: preprocess the old style parentheses config

	let ls = split(p, '\v%(%(start|step|end)\=(.)%(\1@!.)*\1[^ ]*|\w+%(\=[^ ]*)?) ?\zs', 0)
	for s in ls
		let [k, v] = [matchstr(s, '^[^=]\+\ze\(=\|$\)'), matchstr(s, '^[^=]\+=\zs.*')]
		if k == 'step'
			let op = v
		elseif k == 'contains'
			let contains = s:trim(v)
		elseif k == 'containedin'
			let containedin = s:trim(v)
		elseif k == 'contained'
			let contained = v:true
		else
			let paren .= s
		endif
	endfor
	"echom json_encode([paren, contained, containedin, contains, op])
	return [paren, contained, containedin, contains, op]
endfun

fun s:resolve_parenthesis_from_config(config)
	return s:resolve_parenthesis_with(['', v:false, '', 'TOP', a:config.operators], a:config.parentheses_options)
endfun

fun rainbow#syn(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix
	let cycle = conf.cycle
	let def_rg = 'syn region %s matchgroup=%s containedin=%s contains=%s %s'
	let def_op = 'syn match %s %s containedin=%s contained'

	let glob_paran_opts = s:resolve_parenthesis_from_config(conf)
	let b:rainbow_loaded = cycle
	for parenthesis_args in conf.parentheses
		let [paren, contained, containedin, contains, op] = s:resolve_parenthesis_with(glob_paran_opts, parenthesis_args)
		for lv in range(cycle)
			let lv2 = ((lv + cycle - 1) % cycle)
			if len(op) > 0 && op !~ '^..\s*$' |exe printf(def_op, prefix.'_o'.lv, op, prefix.'_r'.lv) |endif
			if lv == 0
				exe printf(def_rg, prefix.'_r0', prefix.'_p0'.(contained? ' contained' : ''), s:concat([containedin, prefix.'_r'.(cycle - 1)]), contains, paren)
			else
				exe printf(def_rg, prefix.'_r'.lv, prefix.'_p'.lv.(' contained'), prefix.'_r'.lv2, contains, paren)
			endif
		endfor
	endfor
	exe 'syn cluster '.prefix.'Regions contains='.join(map(range(cycle), '"'.prefix.'_r".v:val'),',')
	exe 'syn cluster '.prefix.'Parentheses contains='.join(map(range(cycle), '"'.prefix.'_p".v:val'),',')
	exe 'syn cluster '.prefix.'Operators contains='.join(map(range(cycle), '"'.prefix.'_o".v:val'),',')
	if has_key(conf, 'after') | for cmd in conf.after | exe cmd | endfor | endif
endfun

fun rainbow#syn_clear(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix

	for id in range(conf.cycle)
		exe 'syn clear '.prefix.'_r'.id
		exe 'syn clear '.prefix.'_o'.id
	endfor
endfun

fun rainbow#hi(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix

	for id in range(conf.cycle)
		let ctermfg = conf.ctermfgs[id % len(conf.ctermfgs)]
		let guifg = conf.guifgs[id % len(conf.guifgs)]
		let cterm = conf.cterms[id % len(conf.cterms)]
		let gui = conf.guis[id % len(conf.guis)]
		let hi_style = ' ctermfg='.ctermfg.' guifg='.guifg.(len(cterm) > 0 ? ' cterm='.cterm : '').(len(gui) > 0 ? ' gui='.gui : '')
		exe 'hi '.prefix.'_p'.id.hi_style
		exe 'hi '.prefix.'_o'.id.hi_style
	endfor
endfun

fun rainbow#hi_clear(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix

	for id in range(conf.cycle)
		exe 'hi clear '.prefix.'_p'.id
		exe 'hi clear '.prefix.'_o'.id
	endfor
endfun

