" This is the config file of BufExplorer plugin
" To be loaded by .vimrc
"

if exists("loaded_programming_conf")
    finish
endif
let loaded_programming_conf = 1

map <silent> ;ba :breakadd here<CR>
map <silent> ;bdd :breakdel here<CR>
map <silent> ;bda :breakdel *<CR>
map <silent> ;bl :breakl <CR>

