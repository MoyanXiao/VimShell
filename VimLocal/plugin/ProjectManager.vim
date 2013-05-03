if exists("g:loaded_project_manager")
    finish
endif
let g:loaded_project_manager = 1

let g:project_path = $PWD
let g:workspace_path = g:project_path."/workspace/"
let g:project_file = g:workspace_path . "workspace_info"


map <Leader>pc :call project#control#CreateProject()<cr>

if !filereadable(g:project_file)
    finish
endif

echo "Project information file is found, entering..."

let g:config_dict=project#workspaceInfo#LoadWorkSpaceInfo(g:project_file)

if argc() =~ 0
    silent call project#control#StartProject()
endif
silent call project#control#UpdateProject()
