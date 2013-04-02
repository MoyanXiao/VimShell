" vimgen.vim -- Generate text from data and template
" @Author:      <bastian at mathes dot jp>
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2008-03-24

" define new command
com! -range -nargs=0 Vimgen <line1>,<line2>call Vimgen()

" start tag character, default «
if !exists("g:vgen_sc")
	let g:vgen_sc = '«'
endif

" end tag character, default »
if !exists("g:vgen_ec")
	let g:vgen_ec = '»'
endif

" loop character, default !
if !exists("g:vgen_lc")
	let g:vgen_lc = '-'
endif

if !exists("g:vgen_sfc")
	let g:vgen_sfc = "!"
endif

" delimiter
if !exists("g:vgen_delim")
	let g:vgen_delim = "----vimgen----"
endif

" entry point, starts the generation
function! Vimgen() range
	" initialize variables
	let l:line = a:firstline
	let l:is_data = 1
	let l:data_list = []
	let l:template_list = []
	let g:vgen_data = {}
	let g:vgen_vars = []
	let g:vgen_iter = {}

  " read data and template
	while (l:line <= a:lastline)
		if getline(l:line) =~ '^\s*$' && l:is_data
			let l:is_data = 0
		elseif l:is_data
			call add(l:data_list,getline(l:line))
		else
			call add(l:template_list,getline(l:line))
		endif
		let l:line = l:line+1
	endwhile

	" Decho "data_list -> ".string(l:data_list)
	" Decho "template_list -> ".string(l:template_list)

	" do the work
	let g:vgen_data = eval(join(l:data_list,""))
	" Decho "data -> ".string(g:vgen_data)
	let l:output = s:transform_template(join(l:template_list,"\n"))

	" output
	call append(a:lastline, split(g:vgen_delim . "\n" . l:output,"\n"))
endfunction

" this method does the real work
function! s:transform_template(template)
	let l:continue = 1 
	let l:index = 0
	let l:old_index = 0
	let l:script = ""
	let l:template = ""
	let l:guards = []

	while l:continue == 1
		" handle text until next g:vgen_sc
		let l:old_index = l:index
		let l:index = stridx(a:template,g:vgen_sc,l:old_index)
		if l:index == -1
			let l:index = strlen(a:template)
			let l:continue = 0
		endif
		if l:index != l:old_index 
			" handle guards
			for l:guard in l:guards
				let l:script = l:script . "if g:vgen_iter['". l:guard ."'] > 1 | "
			endfor
			let l:script = l:script . "let l:template = l:template . \"" . strpart(a:template,l:old_index,l:index-l:old_index) . "\" | "
			for l:guard in l:guards
				let l:script = l:script . "endif | "
			endfor
		endif
		" handle next command
		if l:index != strlen(a:template)
			let l:old_index = l:index
			let l:index = stridx(a:template,g:vgen_ec,l:old_index)
			if l:index == -1
				throw "incomplete command at the end of the template"		
			endif
			let l:command = strpart(a:template, l:old_index+strlen(g:vgen_sc), l:index-l:old_index-strlen(g:vgen_ec))
			if l:command =~ '^'.g:vgen_lc.'$'
			  " end of loop
			  let l:script = l:script . "endfor" . " | "
				call s:unbind_variable()
			elseif l:command =~ '^'.g:vgen_lc
				" begin of loop
				let l:var_str = substitute(l:command,'^'.g:vgen_lc,'','')
				let l:var = s:get_variable(l:var_str)
				let l:new_var = s:bind_variable(l:var_str,l:var)
				let l:script = l:script . "let g:vgen_iter['". l:var_str ."'] = 0 | for " . l:new_var . " in " . l:var . " | let g:vgen_iter['". l:var_str ."'] = g:vgen_iter['". l:var_str ."'] + 1 | "
			elseif l:command =~ '^'.g:vgen_sfc.'$'
				" end of block not to be printed in first iteration
				call remove(l:guards,0)
			elseif l:command =~ '^'.g:vgen_sfc
				" beginning of block not to be printed in first iteration
				let l:var_str = substitute(l:command,'^'.g:vgen_sfc,'','')
				call insert(l:guards,l:var_str)
			else
				" variable
				let l:var = s:get_variable(l:command)
				let l:script = l:script . "let l:template = l:template . " . l:var . " | "
			endif
			let l:index = l:index+strlen(g:vgen_ec)
		endif
	endwhile

  let l:script = substitute(l:script,' | $','','')      " last delimiter
	" Decho "data -> ".string(g:vgen_data)
	" Decho "script -> ".l:script
	execute l:script
	return l:template
endfunction

" get the vimscript equivalent to the variable in the current context
function! s:get_variable(var_str)
	" Decho "vars -> ".string(g:vgen_vars)
	let l:erg = []
	for l:var in g:vgen_vars
		if a:var_str =~ '^'.l:var[0] 
			let l:erg = l:var
			break
		endif
	endfor
	if l:erg == []
		return "g:vgen_data.".a:var_str
	else
		return l:erg[1].strpart(a:var_str,strlen(l:erg[0]))
	endif
endfunction

" binds a new variable, i.e. create a new context, i.e. push to the stack
function! s:bind_variable(var_str,var)
	for l:var in g:vgen_vars
		if l:var[0] == a:var_str
			throw "variable " . a:var_str . " already bound"
		endif
	endfor
	let l:erg = substitute(a:var,'^g','l','')
	let l:erg = substitute(l:erg,'\.','_','g')
	call insert(g:vgen_vars,[a:var_str,l:erg])	
	return l:erg	
endfunction

" unbinds a variable, i.e. pop from the stack
function! s:unbind_variable()
	call remove(g:vgen_vars,0)
endfunction 
