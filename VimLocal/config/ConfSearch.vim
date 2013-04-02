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

map <unique> <silent> ;cs :call project#operation#CscopeFind('s', 'Search C Sympol:')<CR>
map <unique> <silent> ;cg :call project#operation#CscopeFind('g', "Search Defination:")<CR>
map <unique> <silent> ;cd :call project#operation#CscopeFind('d', "Search Functions called:")<CR>
map <unique> <silent> ;cc :call project#operation#CscopeFind('c', "Search Functions calling:")<CR>
map <unique> <silent> ;ct :call project#operation#CscopeFind('t', "Search assignment:")<CR>
map <unique> <silent> ;ce :call project#operation#CscopeFind('e', "Search egreps:")<CR>
map <unique> <silent> ;cf :call project#operation#CscopeFind('f', "Search files:")<CR>
map <unique> <silent> ;ci :call project#operation#CscopeFind('i', "Search #include files:")<CR>

map <unique> ;chs :call project#operation#CscopeFind('s', "Search Open H C Sympol:", 'h')<CR>
map <unique> ;chg :call project#operation#CscopeFind('g', "Search Open H Defination:", 'h')<CR>
map <unique> ;chd :call project#operation#CscopeFind('d', "Search Open H Functions called:", 'h')<CR>
map <unique> ;chc :call project#operation#CscopeFind('c', "Search Open H Functions calling:", 'h')<CR>
map <unique> ;cht :call project#operation#CscopeFind('t', "Search Open H assignment:", 'h')<CR>
map <unique> ;che :call project#operation#CscopeFind('e', "Search Open H egreps:", 'h')<CR>
map <unique> ;chf :call project#operation#CscopeFind('f', "Search Open H files:", 'h')<CR>
map <unique> ;chi :call project#operation#CscopeFind('i', "Search Open H #include files:", 'h')<CR>

map <unique> ;cvs :call project#operation#CscopeFind('s', "Search Open V C Sympol:", 'v')<CR>
map <unique> ;cvg :call project#operation#CscopeFind('g', "Search Open V Defination:", 'v')<CR>
map <unique> ;cvd :call project#operation#CscopeFind('d', "Search Open V Functions called:", 'v')<CR>
map <unique> ;cvc :call project#operation#CscopeFind('c', "Search Open V Functions calling:", 'v')<CR>
map <unique> ;cvt :call project#operation#CscopeFind('t', "Search Open V assignment:", 'v')<CR>
map <unique> ;cve :call project#operation#CscopeFind('e', "Search Open V egreps:", 'v')<CR>
map <unique> ;cvf :call project#operation#CscopeFind('f', "Search Open V files:", 'v')<CR>
map <unique> ;cvi :call project#operation#CscopeFind('i', "Search Open V #include files:", 'v')<CR>

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
map <unique> ;fu :FufFile<CR>
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
            \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
