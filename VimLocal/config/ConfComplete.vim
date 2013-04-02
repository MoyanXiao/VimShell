" This is the config file of Complete
" To be loaded by .vimrc
"

set completeopt=longest,menu

inoremap <expr> <CR> pumvisible()?"\<C-Y>":"\<CR>"
inoremap <expr> <C-J> pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"
inoremap <expr> <C-K> pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-K>"
inoremap <expr> <C-U> pumvisible()?"\<C-E>":"\<C-U>"

inoremap <C-]> <C-X><C-]>
inoremap <C-F> <C-X><C-F>
inoremap <C-D> <C-X><C-D>
inoremap <C-L> <C-X><C-L>

