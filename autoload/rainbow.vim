" Copyright 2013 LuoChen (luochen1990@gmail.com). Licensed under the Apache License 2.0.

if exists('s:loaded') | finish | endif | let s:loaded = 1

fun s:trim(s)
	return substitute(a:s, '\v^\s*(.{-})\s*$', '\1', '')
endfun

fun s:concat(strs)
	return join(filter(a:strs, "v:val !~ '^[ ]*$'"), ',')
endfun

fun s:resolve_parenthesis_with(init_state, p)
	let [paren, contained, containedin, contains_prefix, contains, op, kind, upkind] = a:init_state
	let p = (type(a:p) == type([])) ? ((len(a:p) == 3) ? printf('start=#%s# step=%s end=#%s#', a:p[0], op, a:p[-1]) : printf('start=#%s# end=#%s#', a:p[0], a:p[-1])) : a:p "NOTE: preprocess the old style parentheses config

	let ls = split(p, '\v%(%(start|step|end)\=(.)%(\1@!.)*\1[^ ]*|\w+%(\=[^ ]*)?) ?\zs', 0)
	for s in ls
		let [k, v] = [matchstr(s, '^[^=]\+\ze\(=\|$\)'), matchstr(s, '^[^=]\+=\zs.*')]
		if k == 'step'
			let op = s:trim(v)
		elseif k == 'contains_prefix'
			let contains_prefix = s:trim(v)
		elseif k == 'contains'
			let contains = s:concat([contains, s:trim(v)])
		elseif k == 'containedin'
			let containedin = s:concat([containedin, s:trim(v)])
		elseif k == 'contained'
			let contained = 1
		elseif k == 'kind'
			let kind = s:trim(v)
		elseif k == 'upkind'
			let upkind = s:trim(v)
		else
			let paren .= s
		endif
	endfor
	let rst = [paren, contained, containedin, contains_prefix, contains, op, kind, upkind]
	"echom json_encode(rst)
	return rst
endfun

fun s:resolve_parenthesis_from_config(config)
	return s:resolve_parenthesis_with(['', 0, '', a:config.contains_prefix, '', a:config.operators, '', ''], a:config.parentheses_options)
endfun

fun s:synID(prefix, group, lv, id)
	return a:prefix.'_lv'.a:lv.'_'.a:group.a:id
endfun

fun s:synGroupID(prefix, group, lv, kind)
	return a:prefix.a:group.'_lv'.a:lv.'_'.a:kind
endfun

fun rainbow#syn(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix
	let cycle = conf.cycle

	let glob_paran_opts = s:resolve_parenthesis_from_config(conf)
	let b:rainbow_loaded = cycle
	let kindlist = {}
	for id in range(len(conf.parentheses))
		let [paren, contained, containedin, contains_prefix, contains, op, kind, upkind] = s:resolve_parenthesis_with(glob_paran_opts, conf.parentheses[id])
		let kind = kind == '' ? [''] : split(kind, ',', 1)->uniq()
		let upkind = (upkind == '' ? [] : split(upkind, ',', 1))->extend(kind)->uniq()
		for k in kind
			if !has_key(kindlist, k)
				let kindlist[k] = []
			endif
			call add(kindlist[k], id)
		endfor
		for lv in range(cycle)
			let uplv = ((lv + cycle - 1) % cycle)
			let [rid, pid, upid] = [s:synID(prefix, 'r', lv, id), s:synID(prefix, 'p', lv, id), upkind->mapnew('"@".s:synGroupID(prefix, "Regions", uplv, v:val)')->join(',')]

			if len(op) > 2
				exe 'syn match '.s:synID(prefix, 'o', lv, id).' '.op.' containedin='.s:synID(prefix, 'r', lv, id).' contained'
			endif

			let real_contained = (lv == 0)? (contained? 'contained ' : '') : 'contained '
			let real_containedin = (lv == 0)? s:concat([containedin, upid]) : upid
			let real_contains = s:concat([contains_prefix, contains])
			exe 'syn region '.rid.' matchgroup='.pid.' '.real_contained.'containedin='.real_containedin.' contains='.real_contains.' '.paren
		endfor
	endfor
	for [kind, ids] in items(kindlist)
		for lv in range(cycle)
			exe 'syn cluster '.s:synGroupID(prefix, 'Regions', lv, kind).' contains='.join(mapnew(ids, 's:synID(prefix, "r", lv, v:val)'), ',')
			exe 'syn cluster '.s:synGroupID(prefix, 'Parentheses', lv, kind).' contains='.join(mapnew(ids, 's:synID(prefix, "p", lv, v:val)'), ',')
			exe 'syn cluster '.s:synGroupID(prefix, 'Operators', lv, kind).' contains='.join(mapnew(ids, 's:synID(prefix, "o", lv, v:val)'), ',')
		endfor
		exe 'syn cluster '.prefix.'Regions_'.kind.' contains='.join(map(range(cycle), '"@".s:synGroupID(prefix, "Regions", v:val, kind)'), ',')
		exe 'syn cluster '.prefix.'Parentheses_'.kind.' contains='.join(map(range(cycle), '"@".s:synGroupID(prefix, "Parentheses", v:val, kind)'), ',')
		exe 'syn cluster '.prefix.'Operators_'.kind.' contains='.join(map(range(cycle), '"@".s:synGroupID(prefix, "Operators", v:val, kind)'), ',')
	endfor
	if has_key(conf, 'after') | for cmd in conf.after | exe cmd | endfor | endif
endfun

fun rainbow#syn_clear(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix

	for id in range(len(conf.parentheses))
		for lv in range(conf.cycle)
			let [rid, oid] = [s:synID(prefix, 'r', lv, id), s:synID(prefix, 'o', lv, id)]
			exe 'syn clear '.rid
			exe 'syn clear '.oid
		endfor
	endfor
endfun

fun rainbow#hi(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix

	for id in range(len(conf.parentheses))
		for lv in range(conf.cycle)
			let [pid, oid] = [s:synID(prefix, 'p', lv, id), s:synID(prefix, 'o', lv, id)]
			let ctermfg = conf.ctermfgs[lv % len(conf.ctermfgs)]
			let guifg = conf.guifgs[lv % len(conf.guifgs)]
			let cterm = conf.cterms[lv % len(conf.cterms)]
			let gui = conf.guis[lv % len(conf.guis)]
			let hi_style = 'ctermfg='.ctermfg.' guifg='.guifg.(len(cterm) > 0 ? ' cterm='.cterm : '').(len(gui) > 0 ? ' gui='.gui : '')
			exe 'hi '.pid.' '.hi_style
			exe 'hi '.oid.' '.hi_style
		endfor
	endfor
endfun

fun rainbow#hi_clear(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix

	for id in range(len(conf.parentheses))
		for lv in range(conf.cycle)
			let [pid, oid] = [s:synID(prefix, 'p', lv, id), s:synID(prefix, 'o', lv, id)]
			exe 'hi clear '.pid
			exe 'hi clear '.oid
		endfor
	endfor
endfun

