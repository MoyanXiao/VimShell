let s:os=system('uname')

if s:os =~ "Darwin"
    let g:Grep_Xargs_Options = "-0"
    let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
endif

