if exists("g:loaded_auto_project_ctrl")
    finish
endif
let g:loaded_auto_project_ctrl=1

function! project#control#CreateProject()
    execute "!mkdir -p ./workspace"
    " TODO edit the file workspace_info
    execute "edit ./workspace/workspace_info"

    call project#control#InitProject()
endfunction

function! project#control#StartProject()
    if filereadable(g:session_file)
        echo "loading session file..."
        silent! execute "so " . g:session_file
    else
        echo "create the session file..."
        set sessionoptions -= "options"
        silent! execute "mksession! ".g:session_file
    endif

    if filereadable(g:viminfo_file)
        echo "loading vim info file..."
        silent! execute "rviminfo! ".g:viminfo_file
    endif
endfunction

function! project#control#InitProject()
    let extList = ['c','h','cpp','hpp', 'vim']
    echo "find the file list in the path " .g:workspace_path.": "
    echo extList
    call project#command#findTagsFileList(g:project_path,
                \g:file_list, extList)
    " TODO add the part of the lookup plugin file buffer
    if hasmapto('LookupFile')
        echo 'Create the tags for lookup plugin...'
        call project#command#findLookupFilelist(
                    \g:project_path,
                    \g:file_tags)
        let g:LookupFile_TagExpr =g:file_tags
    endif

    if executable('ctags')
        echo 'Create the tags of the project...'
        call project#command#createTagFile(
                    \g:file_list,
                    \g:tags_file)
        let &tags=g:tags_file
    endif

    if executable('cscope')
        echo 'Create the cscope DB, may take a long time, waiting...'
        :cs kill -1
        call project#command#createCscopeFile(
                    \g:file_list,
                    \g:cscope_file)
        execute "cs add ".g:cscope_file
    endif
endfunction

function! project#control#CloseProject()
    echo "Save and close the project..."
    silent! execute "mksession! ".g:session_file
    silent! execute "wviminfo! ".g:viminfo_file
    silent! execute "wqall"
endfunction
