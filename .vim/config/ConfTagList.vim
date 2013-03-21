"
" This file is the configuration file of TagList
" It would be sourced in the .vimrc
" 
" Only Linux is supported now
"


if exists('loaded_taglist_conf')
    finish
endif
let loaded_taglist_conf=1

let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1

noremap <silent> <F4> :TlistToggle<cr>

