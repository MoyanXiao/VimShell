if exists("g:loaded_auto_project_workspace")
    finish
endif
let g:loaded_auto_project_workspace=1

function! project#workspaceInfo#LoadWorkSpaceInfo()
    if !exists("g:project_file") || !filereadable(g:project_file)
        let g:config_dict = {}
        return
    endif
    exec 'source' escape(g:project_file, ' \')
endfunction

function! project#workspaceInfo#SaveWorkSpaceInfo()
    let fl = []
    call add(fl, "let g:config_dict = ".string(g:config_dict))
    call writefile(fl, g:project_file)
endfunction

function! project#workspaceInfo#pluginHeader(pluginName, filename)
    if !has_key(g:config_dict, a:pluginName)
        let g:config_dict[a:pluginName] = {}
        let g:config_dict[a:pluginName]["enable"] = "True"
        let g:config_dict[a:pluginName]["loaded"] = "g:".a:pluginName."_loaded"
        let g:config_dict[a:pluginName]["files"] = [a:filename]
        let g:config_dict[a:pluginName]["values"] = {}
        let g:config_dict[a:pluginName]["commands"] = {}
    endif

    let dict = g:config_dict[a:pluginName]
    if index(dict["files"], a:filename) < 0
        call add(dict["files"], a:filename)
    endif
    if dict["enable"] ==? "True" && (!exists(dict["loaded"]) || eval(dict["loaded"]." ==? ".string("False")))  
        exec "let ".dict["loaded"]." = ".string("True")
        return 0
    endif

    return 1
endfunction

function! project#workspaceInfo#printConfigDict()
    call s:printEle(g:config_dict, '  ')
endfunction
" this is commiter

function! project#workspaceInfo#printPluginStatus()
    for key in keys(g:config_dict)
        if key ==? "FileExtense" 
            continue
        endif
        let tmpkey=key
        let upThr = 3
        while len(key)/8 < upThr
            let tmpkey=tmpkey."\t"
            let upThr=upThr-1
        endwhile
        if eval(g:config_dict[key]["loaded"]." ==? ".string("True"))
            echo tmpkey."status=loaded\t ,\tenable=".g:config_dict[key]["enable"]
        else
            echo tmpkey."status=unload\t ,\tenable=".g:config_dict[key]["enable"]
        endif
    endfor
endfunction

nmap <F2> :call project#workspaceInfo#printConfigDict()<CR>
nmap <F4> :call project#workspaceInfo#printPluginStatus()<CR>

function! s:printEle(value, indent)
    if type(a:value) == type({})
        for key in keys(a:value)
            echo a:indent.key.":"
            call s:printEle(a:value[key], a:indent.'  ')
        endfor
    else
        echo a:indent.string(a:value)
    endif
endfunction
