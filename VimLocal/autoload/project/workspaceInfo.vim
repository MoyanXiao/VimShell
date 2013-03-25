if exists("g:loaded_auto_project_workspace")
    finish
endif
let g:loaded_auto_project_workspace=1

function! project#workspaceInfo#LoadWorkSpaceInfo(filename)
    let restDict = {}
    if !filereadable(a:filename)
        return restDict
    endif
    let listContent = readfile(a:filename)
    for items in listContent
        let [key; value]=split(items, "::::")
        let restDict[key]=value
    endfor
    return restDict
endfunction

function! project#workspaceInfo#SaveWorkSpaceInfo(filename, dict)
    let listInfo=[]
    for key in keys(a:dict)
        let tmpItem = [key]
        call extend(tmpItem, a:dict[key])
        call add(listInfo, join(tmpItem, "::::"))
    endfor
    call writefile(listInfo, a:filename)
endfunction
