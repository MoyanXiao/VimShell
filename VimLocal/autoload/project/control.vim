if exists("g:loaded_auto_project_ctrl")
    finish
endif
let g:loaded_auto_project_ctrl=1

let g:session_file = g:workspace_path . 'session.vim'
let g:viminfo_file= g:workspace_path . 'viminfo.vim'
let g:file_list = g:workspace_path . 'files.list'
let g:file_tags = g:workspace_path . 'filetags'
let g:cscope_file = g:workspace_path . 'cscope.out'
let g:tags_file = g:workspace_path . 'tags'
"let g:config_dict = {}

map <Leader>ps :call project#control#SaveProject()<cr>
map <Leader>pq :call project#control#CloseProject()<cr>

function! project#control#CreateProject()
    execute "!mkdir -p ./workspace"
    " TODO edit the file workspace_info
    execute "!touch ".g:project_file
    execute "!chmod a+w ".g:project_file
    "let g:config_dict={'FileExtense':['h','hpp','c','cpp']}
    let stringExt=input("input the extension list, seperate by ' ':")
    if stringExt == ''
        " Default C/C++ project
        let g:config_dict={'FileExtense':['h','hpp','c','cpp']}
    else
        let g:config_dict = {}
        let g:config_dict['FileExtense']=split(stringExt)
    endif
    call project#workspaceInfo#SaveWorkSpaceInfo()
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
    echo "find the file list in the path " .g:workspace_path.": ".string(extList)
    call project#command#findTagsFileList(g:project_path,
                \g:file_list, extList)
    " TODO add the part of the lookup plugin file buffer
    "if hasmapto(':LUTags')
        "echo 'Create the tags for lookup plugin...'
        "call project#command#findLookupFilelist(
                    "\g:project_path,
                    "\g:file_tags,
                    "\extList)
        ""let &tags= g:file_tags
        "let g:LookupFile_TagExpr = 'g:file_tags'
    "endif

    if executable('ctags')
        echo 'Create the tags of the project...'
        call project#command#createTagFile(
                    \g:file_list,
                    \g:tags_file)
        let &tags= g:tags_file.';..//'
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
    call project#workspaceInfo#SaveWorkSpaceInfo()
    exec "tabdo ". "call project#layout#LayoutClose()"
    silent! execute "mksession! ".g:session_file
    silent! execute "wviminfo! ".g:viminfo_file
    silent! execute "wall"
endfunction

function! project#control#CloseProject()
    let quit= confirm("Do you want to close the project(Default: Yes)?", "&Yes\n&No\nCancel", 1)
    if quit==0 || quit==3
        return
    elseif quit == 1
        call project#control#SaveProject()
    endif
    echo "close the project..."
    silent! execute "qall!"
endfunction
