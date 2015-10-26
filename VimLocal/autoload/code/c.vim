if exists("g:loaded_auto_code_c")
    finish
endif
let g:loaded_auto_code_c = 1

let s:LastShellReturnCode	= 0			" for compile / link / run only
let s:C_FilenameEscChar = ' \#%[]'
let s:ScriptIdentity = 'CODE_C_ACTION'

let s:C_CExtension = 'c'
let s:C_ObjExtension = '.o'	
let s:C_ExeExtension = ''	


let s:C_CCompiler = 'clang'
let s:C_CplusCompiler = 'clang++'

let s:C_CFlags = '-Wall -g -O0 -c'
let s:C_LFlags = '-Wall -g -O0'
let s:C_Libs = '-lm'

let s:C_CplusCFlags = '--std=c++11 -Wall -g -O0 -c'
let s:C_CplusLFlags = '--std=c++11 -Wall -g -O0 -lpthread'
let s:C_CplusLibs = '-lm'

let s:C_VimCompilerName = 'gcc'


function!  code#c#Compile()

    let s:C_HlMessage = ""
    exe	":cclose"
    let	Sou		= expand("%:p")											" name of the file in the current buffer
    let	Obj		= expand("%:p:r").s:C_ObjExtension	" name of the object
    let SouEsc= escape( Sou, s:C_FilenameEscChar )
    let ObjEsc= escape( Obj, s:C_FilenameEscChar )

    " update : write source file if necessary
    exe	":update"

    " compilation if object does not exist or object exists and is older then the source
    if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
        " &makeprg can be a string containing blanks
        "call project#common#SaveOptions(s:ScriptIdentity, ['makeprg'], '')
        if expand("%:e") == s:C_CExtension
            exe	"setlocal makeprg=".s:C_CCompiler
            let	compilerflags	= s:C_CFlags
        else
            exe	"setlocal makeprg=".s:C_CplusCompiler
            let	compilerflags	= s:C_CplusCFlags
        endif
        "
        " COMPILATION
        "
        exe ":compiler ".s:C_VimCompilerName
        let v:statusmsg = ''
        let	s:LastShellReturnCode	= 0
        exe	"make "." -o ".ObjEsc." ".compilerflags." ".SouEsc
        if empty(v:statusmsg)
            let s:C_HlMessage = "'".Obj."' : compilation successful"
        endif
        if v:shell_error != 0
            let	s:LastShellReturnCode	= v:shell_error
        endif
        "call project#common#RestoreOptions(s:ScriptIdentity, [])
        "
        " open error window if necessary
        :redraw!
        exe	":botright cwindow"
    else
        let s:C_HlMessage = " '".Obj."' is up to date "
    endif

endfunction    " ----------  end of function C_Compile ----------

function! s:CheckForMain ()
    return  search( '^\(\s*int\s\+\)\=\s*main', "cnw" )
endfunction    " ----------  end of function C_CheckForMain  ----------

function! code#c#Link ()
    call code#c#Compile()
    :redraw!
    if s:LastShellReturnCode != 0
        let	s:LastShellReturnCode	=  0
        return
    endif

    let s:C_HlMessage = ""
    let	Sou		= expand("%:p")						       		" name of the file (full path)
    let	Obj		= expand("%:p:r").s:C_ObjExtension	" name of the object file
    let	Exe		= expand("%:p:r").s:C_ExeExtension	" name of the executable
    let ObjEsc= escape( Obj, s:C_FilenameEscChar )
    let ExeEsc= escape( Exe, s:C_FilenameEscChar )

    if s:CheckForMain() == 0
        let s:C_HlMessage = "no main function in '".Sou."'"
        return
    endif

    " no linkage if:
    "   executable exists
    "   object exists
    "   source exists
    "   executable newer then object
    "   object newer then source

    if    filereadable(Exe)                &&
                \ filereadable(Obj)                &&
                \ filereadable(Sou)                &&
                \ (getftime(Exe) >= getftime(Obj)) &&
                \ (getftime(Obj) >= getftime(Sou))
        let s:C_HlMessage = " '".Exe."' is up to date "
        return
    endif

    " linkage if:
    "   object exists
    "   source exists
    "   object newer then source
    let	linkerflags	= s:C_LFlags 

    if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
        "call project#common#SaveOptions(s:ScriptIdentity, ['makeprg'], '')
        if expand("%:e") == s:C_CExtension
            exe	"setlocal makeprg=".s:C_CCompiler
            let	linkerflags	= s:C_LFlags
        else
            exe	"setlocal makeprg=".s:C_CplusCompiler
            let	linkerflags	= s:C_CplusLFlags 
        endif

        exe ":compiler ".s:C_VimCompilerName
        let	s:LastShellReturnCode	= 0
        let linkerflags = ''
        let v:statusmsg = ''
        exe "make ".linkerflags." ".ObjEsc." ".s:C_Libs." -o ".ExeEsc
        if v:shell_error != 0
            let	s:LastShellReturnCode	= v:shell_error
        endif
        "call project#common#RestoreOptions(s:ScriptIdentity, [])
        "
        if empty(v:statusmsg)
            let s:C_HlMessage = "'".Exe."' : linking successful"
            " open error window if necessary
            :redraw!
            exe	":botright cwindow"
        else
            exe ":botright copen"
        endif
    endif
endfunction
"
let s:C_OutputType = "buffer"
let s:C_OutputBufferName   = "C-Output"
let s:C_OutputBufferNumber = -1
let s:C_RunMsg ="' does not exist or is not executable or object/source older then executable"
let s:C_XtermDefaults = '-fa courier -fs 12 -geometry 80x24'
let s:C_Wrapper ='~/.vim/scripts/wrapper.sh'

function! code#c#ChooseOutput()
    let mod = project#common#Confirm("Choose a output?[".s:C_OutputType."]", ['&buffer','&vim', '&xterm'])
    if mod != ''
        let s:C_OutputType = mod
    endif
endfunction
"
function! code#c#Run ()
    "
    let s:C_HlMessage = ""
    let Sou	= expand("%:p")												" name of the source file
    let Obj	= expand("%:p:r").s:C_ObjExtension		" name of the object file
    let Exe	= expand("%:p:r").s:C_ExeExtension		" name of the executable
    let ExeEsc = escape( Exe, s:C_FilenameEscChar )	" name of the executable, escaped
    let Quote = ''
    let l:arguments     = exists("b:C_CmdLineArgs") ? b:C_CmdLineArgs : ''
    let	l:currentbuffer	= bufname("%")


    if s:C_OutputType == "vim"
        if s:C_ExecutableToRun !~ "^\s*$"
            call C_HlMessage( "executable : '".s:C_ExecutableToRun."'" )
            exe '!'.Quote.s:C_ExecutableToRun.Quote.' '.l:arguments
        else
            call code#c#ExeToRun()
            if s:LastShellReturnCode == 0
                let s:C_HlMessage = ""
                call C_HlMessage()
            endif
            if executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
                exe "!".Quote.ExeEsc.Quote." ".l:arguments
            else
                echomsg "file '".Exe.s:C_RunMsg
            endif
        endif
    endif
    if s:C_OutputType == "buffer"
        let	l:currentbuffernr = bufnr("%")
        "
        if s:C_ExecutableToRun =~ "^\s*$"
            call code#c#ExeToRun()
        endif

        if l:currentbuffer ==  bufname("%")
            if bufloaded(s:C_OutputBufferName) != 0 && bufwinnr(s:C_OutputBufferNumber)!=-1
                exe bufwinnr(s:C_OutputBufferNumber) . "wincmd w"
                " buffer number may have changed, e.g. after a 'save as'
                if bufnr("%") != s:C_OutputBufferNumber
                    let s:C_OutputBufferNumber	= bufnr(s:C_OutputBufferName)
                    exe ":bn ".s:C_OutputBufferNumber
                endif
            else
                silent exe ":botright 15new ".s:C_OutputBufferName
                let s:C_OutputBufferNumber=bufnr("%")
                setlocal buftype=nofile
                setlocal noswapfile
                setlocal syntax=none
                setlocal bufhidden=delete
                setlocal nonumber
                setlocal tabstop=8
            endif
            setlocal modifiable
            if s:C_ExecutableToRun !~ "^\s*$"
                call C_HlMessage( "executable : '".s:C_ExecutableToRun."'" )
                exe	'%!'.Quote.s:C_ExecutableToRun.Quote.' '.l:arguments
                setlocal nomodifiable
                if winheight(winnr()) >= line("$")
                    exe bufwinnr(l:currentbuffernr) . "wincmd w"
                endif
            else
                if	executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
                    exe	"%!".Quote.ExeEsc.Quote." ".l:arguments
                    setlocal nomodifiable
                    if winheight(winnr()) >= line("$")
                        exe bufwinnr(l:currentbuffernr) . "wincmd w"
                    endif
                else
                    setlocal nomodifiable
                    :close
                    echomsg "file '".Exe.s:C_RunMsg
                endif
            endif
        endif
    endif

    if s:C_OutputType == "xterm"
        if s:C_ExecutableToRun !~ "^\s*$"
            silent exe '!xterm -title '.s:C_ExecutableToRun.' '.s:C_XtermDefaults.' -e '.s:C_Wrapper.' '.s:C_ExecutableToRun.' '.l:arguments.' >/dev/null 2>&1 &'
            :redraw!
            call C_HlMessage( "executable : '".s:C_ExecutableToRun."'" )
        else
            silent call code#c#ExeToRun()
            if  executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
                exe '!xterm -title '.ExeEsc.' '.s:C_XtermDefaults.' -e '.s:C_Wrapper.' '.ExeEsc.' '.l:arguments.' >/dev/null 2>&1 &'
                :redraw!
            else
                echomsg "file '".Exe.s:C_RunMsg
            endif
        endif
    endif
endfunction 

function! code#c#Arguments()
    let	Exe	= expand("%:r").s:C_ExeExtension
    if empty(Exe)
        redraw
        echohl WarningMsg | echo "no file name " | echohl None
        return
    endif
    let	prompt	= 'command line arguments for "'.Exe.'" : '
    if exists("b:C_CmdLineArgs")
        let	b:C_CmdLineArgs= project#common#Input( prompt, b:C_CmdLineArgs, 'file' )
    else
        let	b:C_CmdLineArgs= project#common#Input( prompt , "", 'file' )
    endif
endfunction   

let s:C_ExecutableToRun = ''
let s:C_Makefile = ''
let s:C_MakeCmdLineArgs = '' 

function! code#c#ChooseMakefile ()
    let s:C_Makefile	= ''
    let mkfile	= findfile( "Makefile", ".;" )    " try to find a Makefile
    if mkfile == ''
        let mkfile  = findfile( "makefile", ".;" )  " try to find a makefile
    endif
    if mkfile == ''
        let mkfile	= getcwd()
    endif
    let	s:C_Makefile	= project#common#Input ( "choose a Makefile: ", mkfile, "file" )
endfunction

function! code#c#Make()
    exe	":cclose"
    " update : write source file if necessary
    exe	":update"
    " run make
    if s:C_Makefile == ''
        exe	":make ".s:C_MakeCmdLineArgs
    else
        exe	':lchdir  '.fnamemodify( s:C_Makefile, ":p:h" )
        exe	':make -f '.s:C_Makefile.' '.s:C_MakeCmdLineArgs
        exe	":lchdir -"
    endif
    exe	":botright cwindow"
    "
endfunction

function! code#c#MakeClean()
    " run make clean
    if s:C_Makefile == ''
        exe	":!make clean"
    else
        exe	':lchdir  '.fnamemodify( s:C_Makefile, ":p:h" )
        exe	':!make -f '.s:C_Makefile.' clean'
        exe	":lchdir -"
    endif
endfunction

function! code#c#MakeArguments ()
    let	s:C_MakeCmdLineArgs= project#common#Input( 'make command line arguments : ', s:C_MakeCmdLineArgs, 'file' )
endfunction

function! code#c#ExeToRun ()
    let	s:C_ExecutableToRun = project#common#Input( 'executable to run [tab compl.]: ', '', 'file' )
    if s:C_ExecutableToRun !~ "^\s*$"
        let	s:C_ExecutableToRun = escape( getcwd().'/', s:C_FilenameEscChar ).s:C_ExecutableToRun
    endif
endfunction

let s:C_CppcheckSeverity = 'all'

function! code#c#CppcheckCheck ()
    if !executable("cppcheck")
        let s:C_HlMessage = ' Cppcheck is not executable or not installed! '
        call C_HlMessage()
        return
    endif
    let	l:currentbuffer=bufname("%")
    if &filetype != "c" && &filetype != "cpp"
        let s:C_HlMessage = ' "'.l:currentbuffer.'" seems not to be a C/C++ file '
        return
    endif
    let s:C_HlMessage = ""
    exe	":cclose"
    silent exe	":update"
    call project#common#SaveOptions(s:ScriptIdentity, ['makeprg','errorformat'],'')
    setlocal errorformat=[%f:%l]:%m
    setlocal makeprg=cppcheck
    silent exe	"make --enable=".s:C_CppcheckSeverity.' '.escape(l:currentbuffer,s:C_FilenameEscChar)
    call project#common#RestoreOptions(s:ScriptIdentity, [])
    exe	":botright cwindow"
    redraw!
    "
    " message in case of success
    "
    if l:currentbuffer == bufname("%")
        let s:C_HlMessage = " Cppcheck --- no warnings for : ".l:currentbuffer
    endif
endfunction

function! code#c#ChooseCppcheckSeverity()
    let choice = ['&all', '&style', '&performance', 'p&ortability', '&information', '&unusedFunction', '&missingInclude']
    let retval = project#common#Confirm( "cppcheck severity  (current = '".s:C_CppcheckSeverity."' ): ", choice )
    if retval != ''
        let s:C_CppcheckSeverity = retval
    endif
endfunction

function! code#c#CodeCheckArguments ()
    if s:C_CodeCheckIsExecutable==0
        let s:C_HlMessage = ' CodeCheck is not executable or not installed! '
    else
        let	prompt	= 'CodeCheck command line arguments for "'.expand("%").'" : '
        if exists("b:C_CodeCheckCmdLineArgs")
            let	b:C_CodeCheckCmdLineArgs= project#common#Input( prompt, b:C_CodeCheckCmdLineArgs )
        else
            let	b:C_CodeCheckCmdLineArgs= project#common#Input( prompt , s:C_CodeCheckOptions )
        endif
    endif
endfunction

function! code#c#XtermSize ()
    let regex   = '-geometry\s\+\d\+x\d\+'
    let geom    = matchstr( s:C_XtermDefaults, regex )
    let geom    = matchstr( geom, '\d\+x\d\+' )
    let geom    = substitute( geom, 'x', ' ', "" )
    let answer= C_Input("   xterm size (COLUMNS LINES) : ", geom )
    while match(answer, '^\s*\d\+\s\+\d\+\s*$' ) < 0
        let answer= C_Input(" + xterm size (COLUMNS LINES) : ", geom )
    endwhile
    let answer  = substitute( answer, '\s\+', "x", "" )                     " replace inner whitespaces
    let s:C_XtermDefaults = substitute( s:C_XtermDefaults, regex, "-geometry ".answer , "" )
endfunction

function! C_HlMessage ( ... )
    redraw!
    echohl Search
    if a:0 == 0
        echo s:C_HlMessage
    else
        echo a:1
    endif
    echohl None
endfunction
"
"

