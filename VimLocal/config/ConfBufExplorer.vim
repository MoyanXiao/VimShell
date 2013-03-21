" This is the config file of BufExplorer plugin
" To be loaded by .vimrc
"

if exists("loaded_BufExplorer_conf")
    finish
endif
let loaded_BufExplorer_conf = 1

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
