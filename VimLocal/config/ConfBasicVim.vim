" This is the basic configuration file for VIM
"
" To set some options and do some map config
" To be loaded by .vimrc
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.


"if exists('loaded_Basic_Vim_conf')
"    finish
"endif

"let loaded_Basic_Vim_conf = 1

set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" backup options
set backup      " keep a backup file

" basic options
set history=150     " keep 150 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch       " do incremental searching
set hidden
set number
set cursorline
set wildmenu


" display options
set spell
set laststatus=2
set hlsearch    " highlighting the search results
set t_Co=256
set background=dark
colo peaksea
syntax enable
syntax on

" Define the shift and <TAB> ralated options
set shiftwidth=4     " number of spaces for (auto) indent
set tabstop=4        " number of spaces a <TAB> counts for
set expandtab
set smarttab
set textwidth=120
set clipboard+=unnamed
retab

" Format Related options
set linebreak
set whichwrap=b,s,<,>,[,]
set encoding=utf-8
set showmatch
set cindent
set cinoptions=:0g0t0(sus

" Folder options
set foldenable
set foldmethod=syntax
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" Session optionhf
set ssop-=options

" netrw-browse options
let g:netrw_winsize = 30

nnoremap ;qq :q<CR>
nnoremap ;qa :qall<CR>
nnoremap ;qw :wq<CR>
nnoremap ;qs :wqall<CR>

nnoremap ;<F1> :help <C-R>=expand("<cword>")<CR><CR>
