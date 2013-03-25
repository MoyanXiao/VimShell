if exists("g:loaded_project_manager")
    finish
endif
let g:loaded_project_manager = 1

map <Leader>pc :call project#control#CreateProject()<cr>
map <Leader>ps :call project#control#SaveProject()<cr>
map <Leader>pq :call project#control#CloseProject()<cr>

let g:project_path = $PWD
let g:workspace_path = g:project_path."/workspace/"
let g:project_file = g:workspace_path . "workspace_info"
let g:session_file = g:workspace_path . 'session.vim'
let g:viminfo_file= g:workspace_path . 'viminfo.vim'
let g:file_list = g:workspace_path . 'files.list'
let g:file_tags = g:workspace_path . 'filetags'
let g:cscope_file = g:workspace_path . 'cscope.out'
let g:tags_file = g:workspace_path . 'tags'

let g:config_dict = {}

if !filereadable(g:project_file)
    finish
endif

echo "Project information file is found, entering..."

let g:config_dict=project#workspaceInfo#LoadWorkSpaceInfo(g:project_file)
echo g:config_dict

if argc() =~ 0
    call project#control#StartProject()
endif

call project#control#UpdateProject()
