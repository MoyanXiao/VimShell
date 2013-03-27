" This is the config file of BufExplorer plugin
" To be loaded by .vimrc
"

if exists("loaded_Cscope_conf")
    finish
endif
let loaded_Cscope_conf = 1



silent! map <unique> ;s :cs find s <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> ;g :cs find g <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> ;d :cs find d <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> ;c :cs find c <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> ;t :cs find t <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> ;e :cs find e <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> ;f :cs find f <C-R>=expand("<cword>")<CR><CR>
silent! map <unique> ;i :cs find i <C-R>=expand("<cword>")<CR><CR>
