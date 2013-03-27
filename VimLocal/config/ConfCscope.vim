" This is the config file of BufExplorer plugin
" To be loaded by .vimrc
"

if exists("loaded_Cscope_conf")
    finish
endif
let loaded_Cscope_conf = 1



silent! map <unique> <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> <C-\>f :cs find f <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> <C-\>i :cs find i <C-R>=expand("<cword>")<CR><CR>
