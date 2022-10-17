" Copyright 2013 LuoChen (luochen1990@gmail.com). Licensed under the Apache License 2.0.

if exists('s:loaded') | finish | endif | let s:loaded = 1

fun s:trim(s)
	return substitute(a:s, '\v^\s*(.{-})\s*$', '\1', '')
endfun

fun s:concat(strs)
	return join(filter(a:strs, "v:val !~ '^[ ]*$'"), ',')
endfun

fun s:resolve_parenthesis_with(init_state, p)
	let [paren, contained, containedin, contains_prefix, contains, op, cluster] = a:init_state
	let p = (type(a:p) == type([])) ?
				\ ((len(a:p) == 3) ?
				\     printf('start=#%s# step=%s end=#%s#', a:p[0], op, a:p[-1]) :
				\     printf('start=#%s# end=#%s#', a:p[0], a:p[-1])) :
				\ a:p "NOTE: preprocess the old style parentheses config

	let ls = split(p, '\v%(%(start|step|end)\=(.)%(\1@!.)*\1[^ ]*|\w+%(\=[^ ]*)?) ?\zs', 0)
	for s in ls
		let [k, v] = [s:trim(matchstr(s, '^[^=]\+\ze\(=\|$\)')), s:trim(matchstr(s, '^[^=]\+=\zs.*'))]
		if k == 'step'
			let op = v
		elseif k == 'contains_prefix'
			let contains_prefix = v
		elseif k == 'contains'
			let contains = s:concat([contains, v])
		elseif k == 'containedin'
			let containedin = s:concat([containedin, v])
		elseif k == 'contained'
			let contained = 1
		elseif k == 'cluster'
			let cluster = s:concat([cluster, v])
		else
			let paren .= s
		endif
	endfor
	let rst = [paren, contained, containedin, contains_prefix, contains, op, cluster]
	"echom json_encode(rst)
	return rst
endfun

fun s:resolve_parenthesis_from_config(config)
	return s:resolve_parenthesis_with(['', 0, '', a:config.contains_prefix, '', a:config.operators, ''], a:config.parentheses_options)
endfun

fun s:synID(prefix, group, lv, id)
	return a:prefix.'_lv'.a:lv.'_'.a:group.a:id
endfun

fun s:synGroupID(prefix, group, lv, cluster)
	return a:prefix.a:group.'_lv'.a:lv.'_'.a:cluster
endfun

fun rainbow#syn(config)
	let conf = a:config
	let prefix = conf.syn_name_prefix
	let cycle = conf.cycle

	let glob_paran_opts = s:resolve_parenthesis_from_config(conf)
	let b:rainbow_loaded = cycle
	let cluster_list = {}
	for id in range(len(conf.parentheses))
		let [paren, contained, containedin, contains_prefix, contains, op, cluster] = s:resolve_parenthesis_with(glob_paran_opts, conf.parentheses[id])

		let cluster = split(cluster, ',') ?? ['default']
		for k in cluster
			let cluster_list[k] = get(cluster_list, k, [])->add(id)
		endfor
		let containedin_items = split(containedin, ',')
		let upcluster = filter(copy(containedin_items), 'v:val =~ "#.*"')->map('v:val[1:]') ?? cluster
		let containedin = filter(containedin_items, 'v:val !~ "#.*"')->join(',')
		let contains_items = (contains_prefix != '' ? [contains_prefix] : []) + split(contains, ',')

		for lv in range(cycle)
			let uplv = ((lv + cycle - 1) % cycle)
			let [rid, pid, upid] = [s:synID(prefix, 'r', lv, id), s:synID(prefix, 'p', lv, id),
						\ mapnew(upcluster, '"@".s:synGroupID(prefix, "Regions", uplv, v:val)')->join(',')]

			if len(op) > 2
				exe 'syn match '.s:synID(prefix, 'o', lv, id).' '.op.' containedin='.s:synID(prefix, 'r', lv, id).' contained'
			endif

			let real_contained = (lv == 0)? (contained? 'contained ' : '') : 'contained '
			let real_containedin = (lv == 0)? s:concat([containedin, upid]) : upid
			let real_contains = mapnew(contains_items,
						\     'v:val =~ "#.*" ? "@".s:synGroupID(prefix, "Regions", uplv, v:val[1:]) : v:val')
						\ ->flatten()->join(',')
			let real_contains = real_contains != '' ? ' contains='.real_contains : ''
			exe 'syn region '.rid.' matchgroup='.pid.' '.real_contained.'containedin='.real_containedin.real_contains.' '.paren
		endfor
	endfor

	for [kind, abbr] in [['Regions', 'r'], ['Parentheses', 'p'], ['Operators', 'o']]
		for [cluster, ids] in items(cluster_list)
			for lv in range(cycle)
				exe 'syn cluster '.s:synGroupID(prefix, kind, lv, cluster).' contains='.
							\ mapnew(ids, 's:synID(prefix, abbr, lv, v:val)')->join(',')
			endfor
			exe 'syn cluster '.prefix.kind.'_'.cluster.' contains='.
						\ map(range(cycle), '"@".s:synGroupID(prefix, kind, v:val, cluster)')->join(',')
		endfor
		exe 'syn cluster '.prefix.kind.' contains='.map(keys(cluster_list), 'prefix.kind."_".v:val')->join(',')
	endfor

	for cmd in conf->get('after', [])
		exe cmd
	endfor
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

