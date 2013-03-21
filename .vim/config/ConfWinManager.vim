
" This is the config file of winManager plugin
" To be loaded by .vimrc
"

if exists("loaded_winManager_conf")
    finish
endif
let loaded_BufExplorer_conf= 1

let g:winManagerWindowLayout = "BufExplorer,FileExplorer|TagList"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr>
nmap <silent> <F3> :WMToggle<cr>
