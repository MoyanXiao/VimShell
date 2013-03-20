" This is the Linux source file of Vim
"
" Maintainer:	Moyan Xiao<xiaomoyan@gmail.com>
" Last change:	  Thu Mar 21 05:55:53 CST 2013
"
"
" Modified based on vim_example.vim


" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" backup options
set backup		" keep a backup file
set backupext=".bak"

" basic options
set history=150		" keep 150 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set spell
set number
set hlsearch    " highlighting the search results
set wildmenu
syntax on

" Define the shift and <TAB> ralated options
set shiftwidth=4     " number of spaces for (auto) indent
set tabstop=4        " number of spaces a <TAB> counts for
set expandtab
set smarttab
set textwidth=120
set clipboard+=unnamed
colo ron
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

" set mapleader
let mapleader = "\\"

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"Commond for .vimrc
autocmd! bufwritepost .vimrc source ~/.vimrc
