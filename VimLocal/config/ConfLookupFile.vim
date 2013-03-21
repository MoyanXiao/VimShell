" This is the config file of BufExplorer plugin
" To be loaded by .vimrc
"

if exists("loaded_LookupFile_conf")
    finish
endif
let loaded_LookupFile_conf = 1

let g:LookupFile_MinPatLength = 2
let g:LookupFile_PreserveLastPattern = 0
let g:LookupFile_PreservePatternHistory = 1 
let g:LookupFile_AlwaysAcceptFirst = 1
let g:LookupFile_AllowNewFiles = 0 
if filereadable("./filenametags") 
    let g:LookupFile_TagExpr = '"./filenametags"'
endif
nmap <silent> <leader>lk <Plug>LookupFile<cr> 
nmap <silent> <leader>ll :LUBufs<cr> 
nmap <silent> <leader>lw :LUWalk<cr>

nnoremap <buffer> <ESC><ESC> <C-W>q
inoremap <buffer> <ESC><ESC> <ESC><C-W>q
