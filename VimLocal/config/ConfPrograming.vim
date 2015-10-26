" This is the config file of BufExplorer plugin
" To be loaded by .vimrc
"

if exists("loaded_programming_conf")
    finish
endif
let loaded_programming_conf = 1

map <unique> ;bb :wall<CR>:make<CR>
map <silent> <unique> ;bpc :call code#c#Compile()<CR>
map <silent> <unique> ;bpl :call code#c#Link()<CR>
map <silent> <unique> ;bps :call code#c#CppcheckCheck()<CR>

map <unique> ;rco :call code#c#ChooseOutput()<CR>
map <unique> ;rcm :call code#c#ChooseMakefile()<CR>
map <unique> ;rcp :call code#c#MakeArguments()<CR>
map <unique> ;rca :call code#c#Arguments()<CR>
map <unique> ;rce :call code#c#ExeToRun()<CR>

map <unique> ;rr :call code#c#Run()<CR>
map <unique> ;rm :call code#c#Make()<CR>
map <unique> ;rd :call code#c#MakeClean()<CR>

map <unique> <silent> ;bw :cw<CR>
map <unique> <silent> ;bn :cn<CR>
map <unique> <silent> ;bc :ccl<CR>

"map <silent> ;ba :breakadd here<CR>
"map <silent> ;bdd :breakdel here<CR>
"map <silent> ;bda :breakdel *<CR>
"map <silent> ;bl :breakl <CR>

map <silent> <unique> ;ma :call project#function#Help()<CR>
