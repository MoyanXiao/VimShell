if exists("g:loaded_auto_project_operation")
    finish
endif
let g:loaded_auto_project_operation=1

function! project#operation#CscopeFind(cmd, msg,...)
    let key=input(a:msg)
    if a:0 > 0
        if a:1 == 'h'
            let cmd='scs find '
        elseif a:1 == 'v'
            let cmd='vert scs find '
        else
            let cmd='cs find '
        endif
    else
        let cmd='cs find '
    endif

    exec cmd.a:cmd.' '.key
endfunction

function! project#operation#VirtualGrep(cmd) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    let @/ = l:pattern
    let @" = l:saved_reg
    set verbose=0
    exec a:cmd." ".l:pattern
endfunction

let s:replaceTemp=''
function! project#operation#Replace(flag)
    let s:replaceTemp= project#common#Input("Input the replace string: ", s:replaceTemp)
    exec '%s/'.@/.'/'.s:replaceTemp.'/'.a:flag
endfunction
