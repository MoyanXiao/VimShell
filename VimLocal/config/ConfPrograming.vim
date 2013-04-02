" This is the config file of BufExplorer plugin
" To be loaded by .vimrc
"

if exists("loaded_programming_conf")
    finish
endif
let loaded_programming_conf = 1

map <unique> ;bb :make<CR>

map <unique> <silent> ;bw :cw<CR>
map <unique> <silent> ;bn :cn<CR>
map <unique> <silent> ;bp :cw<CR>
map <unique> <silent> ;bc :ccl<CR>

map <silent> ;ba :breakadd here<CR>
map <silent> ;bdd :breakdel here<CR>
map <silent> ;bda :breakdel *<CR>
map <silent> ;bl :breakl <CR>

