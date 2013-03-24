if exists("g:loaded_project_manager")
    finish
endif
let g:loaded_project_manager = 1

map <Leader>lq :call project#control#CloseProject()<cr>

let g:workspace_path = "./workspace/"
let g:project_path = '.'
let g:project_file = g:workspace_path . "workspace_info"
let g:session_file = g:workspace_path . 'session.vim'
let g:file_list = g:workspace_path . 'files.list'
let g:file_tags = g:workspace_path . 'filetags'
let g:cscope_file = g:workspace_path . 'cscope.out'
let g:tags_file = g:workspace_path . 'tags'

if !filereadable(g:project_file)
    finish
endif

echo "Project information file is found, entering..."
if filereadable(g:session_file)
    echo "loading session file..."
   silent! execute "so " . g:session_file
else
    echo "create the session file..."
    set sessionoptions -= "options"
    silent! execute "mksession! ".g:session_file
endif



"function! s:InitPrefix()
    "let s:executable_postfix = ''
    "let s:path_prefix = './'
    "let s:slash = '/'
    "let s:quotation = ''
"endfunction
call project#control#InitProject()
