" This is the config file of BufExplorer plugin
" To be loaded by .vimrc
"

if exists("loaded_Cscope_conf")
    finish
endif
let loaded_Cscope_conf = 1

map <unique> ;gs :cs find s <C-R>=expand("<cword>")<CR><CR>
map <unique> ;gg :cs find g <C-R>=expand("<cword>")<CR><CR>
map <unique> ;gd :cs find d <C-R>=expand("<cword>")<CR><CR>
map <unique> ;gc :cs find c <C-R>=expand("<cword>")<CR><CR>
map <unique> ;gt :cs find t <C-R>=expand("<cword>")<CR><CR>
map <unique> ;ge :cs find e <C-R>=expand("<cword>")<CR><CR>
map <unique> ;gf :cs find f <C-R>=expand("<cword>")<CR><CR>
map <unique> ;gi :cs find i <C-R>=expand("<cword>")<CR><CR>

map <unique> ;cs :cs find s 
map <unique> ;cg :cs find g 
map <unique> ;cd :cs find d 
map <unique> ;cc :cs find c 
map <unique> ;ct :cs find t 
map <unique> ;ce :cs find e 
map <unique> ;cf :cs find f 
map <unique> ;ci :cs find i 

map <unique> ;ts :tag <C-R>=expand("<cword>")<CR><CR>
map <unique> ;tl :tselect <C-R>=expand("<cword>")<CR><CR>
map <unique> ;twl :stselect <C-R>=expand("<cword>")<CR><CR>
map <unique> ;ttl :ptselect <C-R>=expand("<cword>")<CR><CR>
map <unique> ;tj :tjump <C-R>=expand("<cword>")<CR><CR>
map <unique> ;twj :stjump <C-R>=expand("<cword>")<CR><CR>
map <unique> ;ttj :ptjump <C-R>=expand("<cword>")<CR><CR>
map <unique> ;ti <C-]>
map <unique> ;tg :tags<CR>
map <unique> ;tp <C-T>
map <unique> ;tn :tag<CR>
map <unique> ;ttn :tnext<CR>
map <unique> ;ttp :ptp<CR>

map <unique> ;fl [I
map <unique> ;fn ]I
map <unique> ;fcl :ilist

map <unique> ;in :checkpath<CR>
map <unique> ;ia :checkpath!<CR>
