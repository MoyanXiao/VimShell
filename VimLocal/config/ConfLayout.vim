" This is the config file of winManager plugin
" To be loaded by .vimrc
"

let g:winManagerWindowLayout = "BufExplorer|TagList"
let g:winManagerWidth = 30
let g:defaultExplorer = 0
let g:persistentBehaviour=0

let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Enable_Fold_Column=0


let g:NERDTreeMapActivateNode="O"
let g:NERDTreeMapOpenRecursively="o"
let g:NERDTreeMapPreview="<space>"

" open the Tree, TagList and BufExplorer, and move cursor between them
map <unique> <F3> :call project#layout#LayoutToggle()<cr>
map <unique> ;md :call project#layout#LayoutMoveTo(1)<cr>
map <unique> ;mb :call project#layout#LayoutMoveTo(2)<cr>
map <unique> ;ml :call project#layout#LayoutMoveTo(3)<cr>
map <unique> ;mr :call project#layout#LayoutMoveBack()<cr>

" Toggle GUndo"
map <unique> ;un :GundoToggle<CR>

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



