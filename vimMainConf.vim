" This is the Linux source file of Vim
"
" Maintainer:   Moyan Xiao<xiaomoyan@gmail.com>
" Last change:    Thu Mar 21 05:55:53 CST 2013
"
"

" set mapleader
let mapleader = "\\"

" Source the basic config file
source ~/.vim/config/ConfBasicVim.vim

" Source the config file of the plugin
source ~/.vim/config/ConfTagList.vim
source ~/.vim/config/ConfBufExplorer.vim
source ~/.vim/config/ConfWinManager.vim
source ~/.vim/config/ConfLookupFile.vim
source ~/.vim/config/ConfMark.vim
source ~/.vim/config/ConfComplete.vim
source ~/.vim/config/ConfMarkChange.vim
source ~/.vim/config/ConfMRU.vim


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

  set autoindent        " always set autoindenting on

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