if exists("g:loaded_auto_project_common")
    finish
endif
let g:loaded_auto_project_common = 1

let s:global_option_dict = {}
function! project#common#SaveOptions(group, optList, escapeChar)
    let s:global_option_dict[a:group] = {}
    for opt in a:optList
        exe 'let escaped =&'.opt
        let escaped	= escape( escaped, ' |"\'.a:escapeChar )
        let s:global_option_dict[a:group][opt] = escaped
    endfor
endfunction  

function! project#common#RestoreOptions(group, optList)
    if len(a:optList) == 0
        for opt in keys(s:global_option_dict[a:group])
            "exe ':set '.opt.'='.s:global_option_dict[a:group][opt]
            exe "let &".opt."=".s:global_option_dict[a:group][opt]
        endfor
    else
        for opt in a:optList
            "exe ':set '.opt.'='.s:global_option_dict[a:group][opt]
            exe "let &".opt."=".s:global_option_dict[a:group][opt]
        endfor

    endif
endfunction  

function! project#common#Input ( promp, text, ... )
    echohl Search							
    call inputsave()
    if a:0 == 0 || empty(a:1)
        let retval	=input( a:promp, a:text )
    else
        let retval	=input( a:promp, a:text, a:1 )
    endif
    call inputrestore()
    echohl None		
    let retval  = substitute( retval, '^\s\+', "", "" )	
    let retval  = substitute( retval, '\s\+$', "", "" )
    return retval
endfunction  

function! project#common#Confirm( msg, conList, ...)
    if len(a:conList) == 0
        return ""
    endif
    let defopt = 1
    if a:0 > 0 && a:1 > 1
        let defopt = a:1
    endif
    let msg = a:msg
    let rt = confirm(msg, join(a:conList,"\n"), defopt)
    return substitute(a:conList[rt-1], '&', "", "")
endfunction
