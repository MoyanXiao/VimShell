if exists("g:loaded_auto_project_common")
    finish
endif
let g:loaded_auto_project_common = 1

let s:global_option_dict = {}
function! project#common#SaveOptions(group, optList, escapeChar)
    let s:global_option_dict[a:group] = {}
    for opt in a:optList
        exe 'let escaped =&'.opt
        let escaped	= escape( escaped, ' |"\'.escapeChar )
        let s:global_option_dict[a:group][a:optList]	= escaped
    endfor
endfunction  

function! project#common#RestoreOptions(group, optList)
    if len[a:optList] == 0
        for opt in keys(s:global_option_dict[a:group])
            exe ':set '.opt.'='.s:global_option_dict[a:group][opt]
        endfor
    else
        for opt in a:optList
            exe ':set '.opt.'='.s:global_option_dict[a:group][opt]
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
