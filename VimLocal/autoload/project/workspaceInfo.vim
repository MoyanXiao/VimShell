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

function! project#workspaceInfo#pluginHeader(pluginName, filename, ...)
    if !has_key(g:config_dict, a:pluginName)
        let g:config_dict[a:pluginName] = {}
        if a:0 > 0
            let g:config_dict[a:pluginName]["enable"] = a:1
        else
            let g:config_dict[a:pluginName]["enable"] = "True"
        endif
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

function! project#workspaceInfo#LoadPlugin(pluginName)
    if !has_key(g:config_dict, a:pluginName)
        echo "no such plugin : ".a:pluginName
        return
    endif

    if exists(g:config_dict[a:pluginName]["loaded"]) && eval(g:config_dict[a:pluginName]["loaded"]." ==? ".string("True"))
        echo "plugin ".a:pluginName." has been loaded"
        return
    endif
    let g:config_dict[a:pluginName]["enable"] = "True" 
    echo "loading the plugin ".a:pluginName
    exec 'source' escape(g:config_dict[a:pluginName]["files"][0], ' \')
endfunction

function! project#workspaceInfo#SwitchPlugin(pluginName)
    if !has_key(g:config_dict, a:pluginName)
        echo "No such plugin : ".a:pluginName
        return
    endif

    if g:config_dict[a:pluginName]["enable"] ==? "True"
        echo "Toggle pluginName: ".a:pluginName." to False"
        let g:config_dict[a:pluginName]["enable"] = "False"
    else
        echo "Toggle pluginName: ".a:pluginName." to True"
        let g:config_dict[a:pluginName]["enable"] = "True"
    endif
endfunction

function! project#workspaceInfo#FalsePlugin(pluginName)
    if !has_key(g:config_dict, a:pluginName)
        echo "No such plugin : ".a:pluginName
        return
    endif
    echo "Toggle pluginName: ".a:pluginName." to False"
    let g:config_dict[a:pluginName]["enable"] = "False"
endfunction

function! project#workspaceInfo#TruePlugin(pluginName)
    if !has_key(g:config_dict, a:pluginName)
        echo "No such plugin : ".a:pluginName
        return
    endif
    echo "Toggle pluginName: ".a:pluginName." to True"
    let g:config_dict[a:pluginName]["enable"] = "True"
endfunction

function! project#workspaceInfo#printConfigDict()
    call s:printEle(g:config_dict, '  ')
endfunction

function! project#workspaceInfo#printPluginStatus()
    let output = [""]
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
        if exists(g:config_dict[key]["loaded"]) && eval(g:config_dict[key]["loaded"]." ==? ".string("True"))
            call add(output,tmpkey."status:\e[1;32mloaded\e[0m,\tenable:".g:config_dict[key]["enable"].",\tfile:".string(g:config_dict[key]["files"]) )
        else
            call add(output,tmpkey."status:\e[1;31munload\e[0m,\tenable:".g:config_dict[key]["enable"].",\tfile:".string(g:config_dict[key]["files"]) )
        endif
    endfor
    silent execute "!echo -e ".string(join(sort(output), '\n'))
    let toBeToggleRex = project#common#Input("Input the Rex to change:", "")
    if len(toBeToggleRex) == 0
        redraw!
        return
    endif
    let toBeToggle = filter(copy(keys(g:config_dict)), 'v:val !=? "FileExtense" && v:val =~? '.string(toBeToggleRex))
    let toAct = project#common#Confirm( "Any action to the set ".string(toBeToggle),["True", "False", "Switch", "Load", "S&kip"], 5)
    redraw!
    echo "Action to the set ".string(toBeToggle)." is ".toAct."\n"
    if toAct !=? "Skip"
        for pluginName in toBeToggle
            call project#workspaceInfo#{toAct}Plugin(pluginName)
        endfor
    endif
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
