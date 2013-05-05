" ============================================================================
" File:        gundo.vim
" Description: vim global plugin to visualize your undo tree
" Maintainer:  Steve Losh <steve@stevelosh.com>
" License:     GPLv2+ -- look it up.
" Notes:       Much of this code was thiefed from Mercurial, and the rest was
"              heavily inspired by scratch.vim and histwin.vim.
"
" ============================================================================


"{{{ Init
if &cp || project#workspaceInfo#pluginHeader("Gundo", expand("<sfile>:p")) 
    finish
endif
"}}}

"{{{ Misc
command! -nargs=0 GundoToggle call gundo#GundoToggle()
command! -nargs=0 GundoShow call gundo#GundoShow()
command! -nargs=0 GundoHide call gundo#GundoHide()
command! -nargs=0 GundoRenderGraph call gundo#GundoRenderGraph()
"}}}
