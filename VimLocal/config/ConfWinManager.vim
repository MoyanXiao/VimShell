
" This is the config file of winManager plugin
" To be loaded by .vimrc
"

let g:winManagerWindowLayout = "BufExplorer|FileExplorer"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
let g:persistentBehaviour=0
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr>
nmap <silent> <F3> :WMToggle<cr>
