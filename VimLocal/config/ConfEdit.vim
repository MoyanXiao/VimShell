" Supertab config 
let g:SuperTabDefaultCompletionType = "context"
let g:acp_behaviorSnipmateLength = 1

" Move a line of text 
nmap ;mj mz:m+<cr>`z
nmap ;mk mz:m-2<cr>`z
vmap ;mj :m'>+<cr>`<my`>mzgv`yo`z
vmap ;mk :m'<-2<cr>`>my`<mzgv`yo`z

" Default shotcut for xml pretty show
nmap <leader>x <Esc>:set filetype=xml<CR>:%s/></>\r</g<CR><ESC>gg=G<Esc>:noh<CR>

" Config the vimim 
let g:vimim_map='c-bslash'
let g:vimim_toggle='wubi,gbk,cjk'

" config the Mark
nmap <silent> <leader>hl <Plug>MarkSet
vmap <silent> <leader>hl <Plug>MarkSet
nmap <silent> <leader>hh <Plug>MarkClear
vmap <silent> <leader>hh <Plug>MarkClear
nmap <silent> <leader>hr <Plug>MarkRegex
vmap <silent> <leader>hr <Plug>MarkRegex

" config the MarkChange
let showmarks_enable = 0
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let showmarks_ignore_type = "hqm"
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 1
nmap <silent> <leader>mk :MarksBrowser<cr>

" complete settings
set completeopt=longest,menu
inoremap <expr> <CR> pumvisible()?"\<C-Y>":"\<CR>"
inoremap <expr> <C-J> pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"
inoremap <expr> <C-K> pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-K>"
inoremap <expr> <C-U> pumvisible()?"\<C-E>":"\<C-U>"
inoremap <C-]> <C-X><C-]>
inoremap <C-F> <C-X><C-F>
inoremap <C-D> <C-X><C-D>
inoremap <C-L> <C-X><C-L>

map gf :e <cfile><CR>

let g:snipmgr_snippets_dir = "~/code/VimShell/VimLocal/snippets/"

func! AddKey(key)
    let file = expand("~/.vim/keyDictionary/keys.txt")
    let keylist = readfile(file)
    if index(keylist, a:key) == -1
        call add(keylist, a:key)
        call sort(keylist)
        call writefile(keylist, file)
    endif
endfunction
command! -nargs=* AddInKey :call AddKey(<f-args>)
nmap ;aa :AddInKey <C-R>=expand("<cword>")<CR><CR>

set dictionary+=~/.vim/keyDictionary/keys.txt
