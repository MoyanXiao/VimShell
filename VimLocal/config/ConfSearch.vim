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
map <unique> ;gf :cs find f <C-R>=expand("<cfile>")<CR><CR>
map <unique> ;gi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

map <unique> ;ghs :scs find s <C-R>=expand("<cword>")<CR><CR>
map <unique> ;ghg :scs find g <C-R>=expand("<cword>")<CR><CR>
map <unique> ;ghd :scs find d <C-R>=expand("<cword>")<CR><CR>
map <unique> ;ghc :scs find c <C-R>=expand("<cword>")<CR><CR>
map <unique> ;ght :scs find t <C-R>=expand("<cword>")<CR><CR>
map <unique> ;ghe :scs find e <C-R>=expand("<cword>")<CR><CR>
map <unique> ;ghf :scs find f <C-R>=expand("<cfile>")<CR><CR>
map <unique> ;ghi :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

map <unique> ;gvs :vert scs find s <C-R>=expand("<cword>")<CR><CR>
map <unique> ;gvg :vert scs find g <C-R>=expand("<cword>")<CR><CR>
map <unique> ;gvd :vert scs find d <C-R>=expand("<cword>")<CR><CR>
map <unique> ;gvc :vert scs find c <C-R>=expand("<cword>")<CR><CR>
map <unique> ;gvt :vert scs find t <C-R>=expand("<cword>")<CR><CR>
map <unique> ;gve :vert scs find e <C-R>=expand("<cword>")<CR><CR>
map <unique> ;gvf :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
map <unique> ;gvi :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>

map <unique> ;cs :cs find s <C-R>=input("Search C Sympol:")<CR>
map <unique> ;cg :cs find g <C-R>=input("Search Defination:")<CR>
map <unique> ;cd :cs find d <C-R>=input("Search Functions called:")<CR>
map <unique> ;cc :cs find c <C-R>=input("Search Functions calling:")<CR>
map <unique> ;ct :cs find t <C-R>=input("Search assignment:")<CR>
map <unique> ;ce :cs find e <C-R>=input("Search egreps:")<CR>
map <unique> ;cf :cs find f <C-R>=input("Search files:")<CR>
map <unique> ;ci :cs find i <C-R>=input("Search #include files:")<CR>

map <unique> ;chs :scs find s <C-R>=input("Search Open H C Sympol:")<CR>
map <unique> ;chg :scs find g <C-R>=input("Search Open H Defination:")<CR>
map <unique> ;chd :scs find d <C-R>=input("Search Open H Functions called:")<CR>
map <unique> ;chc :scs find c <C-R>=input("Search Open H Functions calling:")<CR>
map <unique> ;cht :scs find t <C-R>=input("Search Open H assignment:")<CR>
map <unique> ;che :scs find e <C-R>=input("Search Open H egreps:")<CR>
map <unique> ;chf :scs find f <C-R>=input("Search Open H files:")<CR>
map <unique> ;chi :scs find i <C-R>=input("Search Open H #include files:")<CR>

map <unique> ;cvs :vert scs find s <C-R>=input("Search Open V C Sympol:")<CR>
map <unique> ;cvg :vert scs find g <C-R>=input("Search Open V Defination:")<CR>
map <unique> ;cvd :vert scs find d <C-R>=input("Search Open V Functions called:")<CR>
map <unique> ;cvc :vert scs find c <C-R>=input("Search Open V Functions calling:")<CR>
map <unique> ;cvt :vert scs find t <C-R>=input("Search Open V assignment:")<CR>
map <unique> ;cve :vert scs find e <C-R>=input("Search Open V egreps:")<CR>
map <unique> ;cvf :vert scs find f <C-R>=input("Search Open V files:")<CR>
map <unique> ;cvi :vert scs find i <C-R>=input("Search Open V #include files:")<CR>

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
map <unique> ;fj :jumps<CR>
map <unique> ;fo <C-O>
map <unique> ;fi <C-I>
map <unique> ;fc :changes<CR>

map <unique> ;in :checkpath<CR>
map <unique> ;ia :checkpath!<CR>

map <unique> ;ff :CtrlP<CR>
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
            \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
