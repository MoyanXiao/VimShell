if &cp || project#workspaceInfo#pluginHeader("ProjectManager", expand("<sfile>:p")) 
    finish
endif

map <Leader>pc :call project#control#CreateProject()<cr>

if !filereadable(g:project_file)
    finish
endif
echo "Project information file is found, entering..."


if argc() =~ 0
    silent call project#control#StartProject()
endif
silent call project#control#UpdateProject()
