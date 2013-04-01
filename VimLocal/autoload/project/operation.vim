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
