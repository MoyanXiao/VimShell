if exists("g:loaded_auto_project_cmd")
    finish
endif
let g:loaded_auto_project_cmd=1

if !exists('Tlist_Ctags_Cmd')
    let Tlist_Ctags_Cmd='ctags'
endif

function! project#command#findTagsFileList(curPath, targetFile, extList)
    let tmpCmd = '!find '.a:curPath
    if empty(a:extList)
        return ''
    endif
    let tmpCmd = tmpCmd.' -name "*.'.a:extList[0].'"' 
    let index = 1
    while index < len(a:extList)
        let tmpCmd = tmpCmd.' -o -name "*.'.a:extList[index].'"'
        let index = index+1
    endwhile
    let tmpCmd = tmpCmd.' > '.a:targetFile
    execute tmpCmd
endfunction

function! project#command#findLookupFilelist(curPath, targetFile, extList)
    execute '!echo -e "\!_TAG_FILE_SORTED\t2\t/2=foldcase" > ' . a:targetFile 
    let tmpCmd = '!find '.a:curPath
    if empty(a:extList)
        return ''
    endif
    let tmpCmd = tmpCmd.' -name "*.'.a:extList[0].'"' 
    let index = 1
    while index < len(a:extList)
        let tmpCmd = tmpCmd.' -o -name "*.'.a:extList[index].'"'
        let index = index+1
    endwhile
    let tmpCmd = tmpCmd.' -type f -printf "\%f\t\%p\t1\n"|grep -v "\.git" | sort -f >>'.a:targetFile 
    execute tmpCmd
endfunction

function! project#command#createTagFile(listFile, tagFile)
    execute '!'.g:Tlist_Ctags_Cmd.' -f ' . a:tagFile .
                \' -R --c++-kinds=+p --fields=+aiS --extra=+q --tag-relative=no ' .
                \' -L ' . a:listFile 
endfunction

function! project#command#createCscopeFile(listFile, cscopeFile)
    execute '!cscope -Rbqk -i ' . a:listFile . ' -f ' . a:cscopeFile 
endfunction


