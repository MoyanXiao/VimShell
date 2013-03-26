if exists("g:loaded_auto_project_ctrl")
    finish
endif
let g:loaded_auto_project_ctrl=1

function! project#control#CreateProject()
    execute "!mkdir -p ./workspace"
    " TODO edit the file workspace_info
    execute "!touch ".g:project_file
    execute "!chmod a+w ".g:project_file
    "let g:config_dict={'FileExtense':['h','hpp','c','cpp']}
    let stringExt=input("input the extension list, seperate by ' ':")
    if stringExt =~ ''
        " Default C/C++ project
        let g:config_dict={'FileExtense':['h','hpp','c','cpp']}
    else
        let g:config_dict['FileExtense']=split(stringExt)
    endif
    call project#workspaceInfo#SaveWorkSpaceInfo(g:project_file, g:config_dict)
    call project#control#UpdateProject()
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
  
function! project#control#UpdateProject()
    let extList = g:config_dict['FileExtense']
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
        let &tags=g:file_tags
    endif

    if executable('ctags')
        echo 'Create the tags of the project...'
        call project#command#createTagFile(
                    \g:file_list,
                    \g:tags_file)
        let &tags= &tags.",".g:tags_file.';..//'
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

function! project#control#SaveProject()
    echo "Save the project ..."
    call project#workspaceInfo#SaveWorkSpaceInfo(g:project_file, g:config_dict)
    silent! execute "mksession! ".g:session_file
    silent! execute "wviminfo! ".g:viminfo_file
    silent! execute "wall"
endfunction

function! project#control#CloseProject()
    let quit=input("Do you want to save before the project is closed?('n' to exit without save)")
    if quit !~ 'n' && quit !~ 'N'
        call project#control#SaveProject()
    endif
    echo "close the project..."
    silent! execute "qall!"
endfunction
