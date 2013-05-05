if exists("g:loaded_project_manager")
    finish
endif
let g:loaded_project_manager = 1

let g:project_path = $PWD
let g:workspace_path = g:project_path."/workspace/"
let g:project_file = g:workspace_path . "workspace_info"


map <Leader>pc :call project#control#CreateProject()<cr>

call project#workspaceInfo#LoadWorkSpaceInfo()

if !filereadable(g:project_file)
    finish
endif
echo "Project information file is found, entering..."


if argc() =~ 0
    silent call project#control#StartProject()
endif
call project#control#UpdateProject()
