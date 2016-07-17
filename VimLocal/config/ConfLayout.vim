" This is the config file of winManager plugin
" To be loaded by .vimrc
"
" window manager config
let g:winManagerWindowLayout = "BufExplorer|TagList"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
let g:persistentBehaviour=0

" airline
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" airline-tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 0 " # of splits (default)
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap ;1 <Plug>AirlineSelectTab1
nmap ;2 <Plug>AirlineSelectTab2
nmap ;3 <Plug>AirlineSelectTab3
nmap ;4 <Plug>AirlineSelectTab4
nmap ;5 <Plug>AirlineSelectTab5
nmap ;6 <Plug>AirlineSelectTab6
nmap ;7 <Plug>AirlineSelectTab7
nmap ;8 <Plug>AirlineSelectTab8
nmap ;9 <Plug>AirlineSelectTab9
nmap <C-H> <Plug>AirlineSelectPrevTab
nmap <C-L> <Plug>AirlineSelectNextTab




" BufExplorer config 
let g:bufExplorerDefaultHelp=0 " Do not show default help.
let g:bufExplorerShowRelativePath=1 " Show relative paths.
let g:bufExplorerSortBy='mru' " Sort by most recently used.
let g:bufExplorerSplitRight=0 " Split left.
let g:bufExplorerSplitVertical=1 " Split vertically.
let g:bufExplorerSplitVertSize = 30 " Split width
let g:bufExplorerUseCurrentWindow=1 " Open in new window.
autocmd BufWinEnter \[Buf\ List\] setl nonumber

noremap <script> <silent> <unique> <Leader>be :BufExplorer<CR>
noremap <script> <silent> <unique> <Leader>bs :BufExplorerHorizontalSplit<CR>
noremap <script> <silent> <unique> <Leader>bv :BufExplorerVerticalSplit<CR>

" TagList config
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Enable_Fold_Column=0

" NERD tree config 
let g:NERDTreeMapActivateNode="O"
let g:NERDTreeMapOpenRecursively="o"
let g:NERDTreeMapPreview="<space>"

" open the Tree, TagList and BufExplorer, and move cursor between them
map <silent> <unique> <F3> :call project#layout#LayoutToggle()<cr>
map <silent> <unique> ;mm :call project#layout#LayoutToggle()<cr>
map <silent> <unique> ;md :call project#layout#LayoutMoveTo(1)<cr>
map <silent> <unique> ;mb :call project#layout#LayoutMoveTo(2)<cr>
map <silent> <unique> ;ml :call project#layout#LayoutMoveTo(3)<cr>
map <silent> <unique> ;mr :call project#layout#LayoutMoveBack()<cr>

" Toggle GUndo"
map <unique> ;un :GundoToggle<CR>

" Lookupfile config 
let g:LookupFile_MinPatLength = 2
let g:LookupFile_PreserveLastPattern = 0
let g:LookupFile_PreservePatternHistory = 0 
let g:LookupFile_AlwaysAcceptFirst = 0
let g:LookupFile_AllowNewFiles = 0 
nmap <silent> <leader>lt :LUTags<cr>
nmap <silent> <leader>lb :LUBufs<cr> 
nmap <silent> <leader>lw :LUWalk<cr>

" MRU config
let MRU_File="/tmp/.vim_mru_file"
let MRU_Max_Entries=1000
let MRU_Exclude_Files='^/tmp/.*\|^/var/tmp/.*'  "Do not include the file in tmp
let MRU_Window_Height=15

" Remap window operations
map <unique> ;ws <C-W><C-S>
map <unique> ;wv <C-W><C-V>
map <unique> ;ww <C-W><C-W>
map <unique> ;wq <C-W><C-Q>
map <unique> ;wj <C-W>j
map <unique> ;wk <C-W>k
map <unique> ;wl <C-W>l
map <unique> ;wh <C-W>h
map <unique> ;wmj <C-W>J
map <unique> ;wmk <C-W>K
map <unique> ;wml <C-W>L
map <unique> ;wmh <C-W>H
map <unique> ;wt <C-W>T
map <unique> ;w= <C-W>=
map <unique> ;wf <C-W>f
map <unique> ;wi <C-W><C-I>

" Remap tab page operations
map <unique> ;pn :tabnew<CR>
map <unique> ;po :tabonly<CR>
map <unique> ;pc :tabclose<CR> 
map <unique> ;pp :tabs<CR> 
map <unique> ;pl gt
map <unique> ;ph gT
map <unique> ;p^ :tabfirst<CR>
map <unique> ;p$ :tablast<CR>

" ConqueTerm
let g:ConqueTerm_SessionSupport = 1
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_InsertOnEnter = 1
let g:ConqueTerm_CWInsert = 0
let g:ConqueTerm_CloseOnEnd = 1



