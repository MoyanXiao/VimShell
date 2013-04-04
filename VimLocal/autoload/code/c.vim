if exists("g:loaded_auto_code_c")
    finish
endif
let g:loaded_auto_code_c = 1

"
"------------------------------------------------------------------------------
"  C_Compile : C_Compile       {{{1
"------------------------------------------------------------------------------
"  The standard make program 'make' called by vim is set to the C or C++ compiler
"  and reset after the compilation  (setlocal makeprg=... ).
"  The errorfile created by the compiler will now be read by gvim and
"  the commands cl, cp, cn, ... can be used.
"------------------------------------------------------------------------------
let s:LastShellReturnCode	= 0			" for compile / link / run only

function! C_Compile ()

    let s:C_HlMessage = ""
    exe	":cclose"
    let	Sou		= expand("%:p")											" name of the file in the current buffer
    let	Obj		= expand("%:p:r").s:C_ObjExtension	" name of the object
    let SouEsc= escape( Sou, s:C_FilenameEscChar )
    let ObjEsc= escape( Obj, s:C_FilenameEscChar )
    let	compilerflags	= ''

    " update : write source file if necessary
    exe	":update"

    " compilation if object does not exist or object exists and is older then the source
    if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
        " &makeprg can be a string containing blanks
        call s:C_SaveGlobalOption('makeprg')
        if expand("%:e") == s:C_CExtension
            exe		"setlocal makeprg=".s:C_CCompiler
            let	compilerflags	= s:C_CFlags
        else
            exe		"setlocal makeprg=".s:C_CplusCompiler
            let	compilerflags	= s:C_CplusCFlags 
        endif
        "
        " COMPILATION
        "
        exe ":compiler ".s:C_VimCompilerName
        let v:statusmsg = ''
        let	s:LastShellReturnCode	= 0
        exe		"make ".compilerflags." ".SouEsc." -o ".ObjEsc
        if empty(v:statusmsg)
            let s:C_HlMessage = "'".Obj."' : compilation successful"
        endif
        if v:shell_error != 0
            let	s:LastShellReturnCode	= v:shell_error
        endif
        call s:C_RestoreGlobalOption('makeprg')
        "
        " open error window if necessary
        :redraw!
        exe	":botright cwindow"
    else
        let s:C_HlMessage = " '".Obj."' is up to date "
    endif

endfunction    " ----------  end of function C_Compile ----------

function! C_CheckForMain ()
    return  search( '^\(\s*int\s\+\)\=\s*main', "cnw" )
endfunction    " ----------  end of function C_CheckForMain  ----------
"
"------------------------------------------------------------------------------
"  C_Link : C_Link       {{{1
"------------------------------------------------------------------------------
"  The standard make program which is used by gvim is set to the compiler
"  (for linking) and reset after linking.
"
"  calls: C_Compile
"------------------------------------------------------------------------------
function! C_Link ()

    call	C_Compile()
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
    if s:MSWIN
        let	ObjEsc	= '"'.ObjEsc.'"'
        let	ExeEsc	= '"'.ExeEsc.'"'
    endif

    if C_CheckForMain() == 0
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
        call s:C_SaveGlobalOption('makeprg')
        if expand("%:e") == s:C_CExtension
            exe		"setlocal makeprg=".s:C_CCompiler
            let	linkerflags	= s:C_LFlags
        else
            exe		"setlocal makeprg=".s:C_CplusCompiler
            let	linkerflags	= s:C_CplusLFlags 
        endif
        exe ":compiler ".s:C_VimCompilerName
        let	s:LastShellReturnCode	= 0
        let v:statusmsg = ''
        silent exe "make ".linkerflags." -o ".ExeEsc." ".ObjEsc." ".s:C_Libs
        if v:shell_error != 0
            let	s:LastShellReturnCode	= v:shell_error
        endif
        call s:C_RestoreGlobalOption('makeprg')
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
endfunction    " ----------  end of function C_Link ----------
"
"------------------------------------------------------------------------------
"  C_Run : 	C_Run       {{{1
"  calls: C_Link
"------------------------------------------------------------------------------
"
let s:C_OutputBufferName   = "C-Output"
let s:C_OutputBufferNumber = -1
let s:C_RunMsg1						 ="' does not exist or is not executable or object/source older then executable"
let s:C_RunMsg2						 ="' does not exist or is not executable"
"
function! C_Run ()
    "
    let s:C_HlMessage = ""
    let Sou  					= expand("%:p")												" name of the source file
    let Obj  					= expand("%:p:r").s:C_ObjExtension		" name of the object file
    let Exe  					= expand("%:p:r").s:C_ExeExtension		" name of the executable
    let ExeEsc  			= escape( Exe, s:C_FilenameEscChar )	" name of the executable, escaped
    let Quote					= ''
    if s:MSWIN
        let Quote					= '"'
    endif
    "
    let l:arguments     = exists("b:C_CmdLineArgs") ? b:C_CmdLineArgs : ''
    "
    let	l:currentbuffer	= bufname("%")
    "
    "==============================================================================
    "  run : run from the vim command line
    "==============================================================================
    if s:C_OutputGvim == "vim"
        "
        if s:C_ExecutableToRun !~ "^\s*$"
            call C_HlMessage( "executable : '".s:C_ExecutableToRun."'" )
            exe		'!'.Quote.s:C_ExecutableToRun.Quote.' '.l:arguments
        else

            silent call C_Link()
            if s:LastShellReturnCode == 0
                " clear the last linking message if any"
                let s:C_HlMessage = ""
                call C_HlMessage()
            endif
            "
            if	executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
                exe		"!".Quote.ExeEsc.Quote." ".l:arguments
            else
                echomsg "file '".Exe.s:C_RunMsg1
            endif
        endif

    endif
    "
    "==============================================================================
    "  run : redirect output to an output buffer
    "==============================================================================
    if s:C_OutputGvim == "buffer"
        let	l:currentbuffernr	= bufnr("%")
        "
        if s:C_ExecutableToRun =~ "^\s*$"
            call C_Link()
        endif
        if l:currentbuffer ==  bufname("%")
            "
            "
            if bufloaded(s:C_OutputBufferName) != 0 && bufwinnr(s:C_OutputBufferNumber)!=-1
                exe bufwinnr(s:C_OutputBufferNumber) . "wincmd w"
                " buffer number may have changed, e.g. after a 'save as'
                if bufnr("%") != s:C_OutputBufferNumber
                    let s:C_OutputBufferNumber	= bufnr(s:C_OutputBufferName)
                    exe ":bn ".s:C_OutputBufferNumber
                endif
            else
                silent exe ":new ".s:C_OutputBufferName
                let s:C_OutputBufferNumber=bufnr("%")
                setlocal buftype=nofile
                setlocal noswapfile
                setlocal syntax=none
                setlocal bufhidden=delete
                setlocal tabstop=8
            endif
            "
            " run programm
            "
            setlocal	modifiable
            if s:C_ExecutableToRun !~ "^\s*$"
                call C_HlMessage( "executable : '".s:C_ExecutableToRun."'" )
                exe		'%!'.Quote.s:C_ExecutableToRun.Quote.' '.l:arguments
                setlocal	nomodifiable
                "
                if winheight(winnr()) >= line("$")
                    exe bufwinnr(l:currentbuffernr) . "wincmd w"
                endif
            else
                "
                if	executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
                    exe		"%!".Quote.ExeEsc.Quote." ".l:arguments
                    setlocal	nomodifiable
                    "
                    if winheight(winnr()) >= line("$")
                        exe bufwinnr(l:currentbuffernr) . "wincmd w"
                    endif
                else
                    setlocal	nomodifiable
                    :close
                    echomsg "file '".Exe.s:C_RunMsg1
                endif
            endif
            "
        endif
    endif
endfunction    " ----------  end of function C_Run ----------
"
"------------------------------------------------------------------------------
"  C_Arguments : Arguments for the executable       {{{1
"------------------------------------------------------------------------------
function! C_Arguments ()
    let	Exe		  = expand("%:r").s:C_ExeExtension
    if empty(Exe)
        redraw
        echohl WarningMsg | echo "no file name " | echohl None
        return
    endif
    let	prompt	= 'command line arguments for "'.Exe.'" : '
    if exists("b:C_CmdLineArgs")
        let	b:C_CmdLineArgs= C_Input( prompt, b:C_CmdLineArgs, 'file' )
    else
        let	b:C_CmdLineArgs= C_Input( prompt , "", 'file' )
    endif
endfunction    " ----------  end of function C_Arguments ----------
"
"
"------------------------------------------------------------------------------
"  run make(1)       {{{1
"------------------------------------------------------------------------------
let s:C_ExecutableToRun	    = ''
let s:C_Makefile						= ''
let s:C_MakeCmdLineArgs   	= ''   " command line arguments for Run-make; initially empty
"
"------------------------------------------------------------------------------
"  C_ChooseMakefile : choose a makefile       {{{1
"------------------------------------------------------------------------------
function! C_ChooseMakefile ()
    let s:C_Makefile	= ''
    let mkfile	= findfile( "Makefile", ".;" )    " try to find a Makefile
    if mkfile == ''
        let mkfile  = findfile( "makefile", ".;" )  " try to find a makefile
    endif
    if mkfile == ''
        let mkfile	= getcwd()
    endif
    let	s:C_Makefile	= C_Input ( "choose a Makefile: ", mkfile, "file" )
endfunction    " ----------  end of function C_ChooseMakefile  ----------
"
"------------------------------------------------------------------------------
"  C_Make : run make       {{{1
"------------------------------------------------------------------------------
function! C_Make()
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
endfunction    " ----------  end of function C_Make ----------
"
"------------------------------------------------------------------------------
"  C_MakeClean : run 'make clean'       {{{1
"------------------------------------------------------------------------------
function! C_MakeClean()
    " run make clean
    if s:C_Makefile == ''
        exe	":!make clean"
    else
        exe	':lchdir  '.fnamemodify( s:C_Makefile, ":p:h" )
        exe	':!make -f '.s:C_Makefile.' clean'
        exe	":lchdir -"
    endif
endfunction    " ----------  end of function C_MakeClean ----------

"------------------------------------------------------------------------------
"  C_MakeArguments : get make command line arguments       {{{1
"------------------------------------------------------------------------------
function! C_MakeArguments ()
    let	s:C_MakeCmdLineArgs= C_Input( 'make command line arguments : ', s:C_MakeCmdLineArgs, 'file' )
endfunction    " ----------  end of function C_MakeArguments ----------

"------------------------------------------------------------------------------
"  C_ExeToRun : choose executable to run       {{{1
"------------------------------------------------------------------------------
function! C_ExeToRun ()
    let	s:C_ExecutableToRun = C_Input( 'executable to run [tab compl.]: ', '', 'file' )
    if s:C_ExecutableToRun !~ "^\s*$"
        let	s:C_ExecutableToRun = escape( getcwd().'/', s:C_FilenameEscChar ).s:C_ExecutableToRun
    endif
endfunction    " ----------  end of function C_ExeToRun ----------
"
"------------------------------------------------------------------------------
"  C_SplintArguments : splint command line arguments       {{{1
"------------------------------------------------------------------------------
function! C_SplintArguments ()
    if s:C_SplintIsExecutable==0
        let s:C_HlMessage = ' Splint is not executable or not installed! '
    else
        let	prompt	= 'Splint command line arguments for "'.expand("%").'" : '
        if exists("b:C_SplintCmdLineArgs")
            let	b:C_SplintCmdLineArgs= C_Input( prompt, b:C_SplintCmdLineArgs )
        else
            let	b:C_SplintCmdLineArgs= C_Input( prompt , "" )
        endif
    endif
endfunction    " ----------  end of function C_SplintArguments ----------
"
"------------------------------------------------------------------------------
"  C_SplintCheck : run splint(1)        {{{1
"------------------------------------------------------------------------------
function! C_SplintCheck ()
    if s:C_SplintIsExecutable==0
        let s:C_HlMessage = ' Splint is not executable or not installed! '
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
    call s:C_SaveGlobalOption('makeprg')
    :setlocal makeprg=splint
    "
    let l:arguments  = exists("b:C_SplintCmdLineArgs") ? b:C_SplintCmdLineArgs : ' '
    silent exe	"make ".l:arguments." ".escape(l:currentbuffer,s:C_FilenameEscChar)
    call s:C_RestoreGlobalOption('makeprg')
    exe	":botright cwindow"
    "
    " message in case of success
    "
    if l:currentbuffer == bufname("%")
        let s:C_HlMessage = " Splint --- no warnings for : ".l:currentbuffer
    endif
endfunction    " ----------  end of function C_SplintCheck ----------
"
"------------------------------------------------------------------------------
"  C_CppcheckCheck : run cppcheck(1)        {{{1
"------------------------------------------------------------------------------
function! C_CppcheckCheck ()
    if s:C_CppcheckIsExecutable==0
        let s:C_HlMessage = ' Cppcheck is not executable or not installed! '
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
    call s:C_SaveGlobalOption('makeprg')
    call s:C_SaveGlobalOption('errorformat')
    setlocal errorformat=[%f:%l]:%m
    :setlocal makeprg=cppcheck
    silent exe	"make --enable=".s:C_CppcheckSeverity.' '.escape(l:currentbuffer,s:C_FilenameEscChar)
    call s:C_RestoreGlobalOption('makeprg')
    exe	":botright cwindow"
    "
    " message in case of success
    "
    if l:currentbuffer == bufname("%")
        let s:C_HlMessage = " Cppcheck --- no warnings for : ".l:currentbuffer
    endif
endfunction    " ----------  end of function C_CppcheckCheck ----------

"===  FUNCTION  ================================================================
"          NAME:  C_CppcheckSeverityList     {{{1
"   DESCRIPTION:  cppcheck severity : callback function for completion
"    PARAMETERS:  ArgLead - 
"                 CmdLine - 
"                 CursorPos - 
"       RETURNS:  
"===============================================================================
function!	C_CppcheckSeverityList ( ArgLead, CmdLine, CursorPos )
    return filter( copy( s:CppcheckSeverity ), 'v:val =~ "\\<'.a:ArgLead.'\\w*"' )
endfunction    " ----------  end of function C_CppcheckSeverityList  ----------

"===  FUNCTION  ================================================================
"          NAME:  C_GetCppcheckSeverity     {{{1
"   DESCRIPTION:  cppcheck severity : used in command definition
"    PARAMETERS:  severity - cppcheck severity
"       RETURNS:  
"===============================================================================
function! C_GetCppcheckSeverity ( severity )
    let	sev	= a:severity
    let sev	= substitute( sev, '^\s\+', '', '' )  	     			" remove leading whitespaces
    let sev	= substitute( sev, '\s\+$', '', '' )	       			" remove trailing whitespaces
    "
    if index( s:CppcheckSeverity, tolower(sev) ) >= 0
        let s:C_CppcheckSeverity = sev
        echomsg "cppcheck severity is set to '".s:C_CppcheckSeverity."'"
    else
        let s:C_CppcheckSeverity = 'all'			                        " the default
        echomsg "wrong argument '".a:severity."' / severity is set to '".s:C_CppcheckSeverity."'"
    endif
    "
endfunction    " ----------  end of function C_GetCppcheckSeverity  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  C_CppcheckSeverityInput
"   DESCRIPTION:  read cppcheck severity from the command line
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! C_CppcheckSeverityInput ()
    let retval = input( "cppcheck severity  (current = '".s:C_CppcheckSeverity."' / tab exp.): ", '', 'customlist,C_CppcheckSeverityList' )
    redraw!
    call C_GetCppcheckSeverity( retval )
    return
endfunction    " ----------  end of function C_CppcheckSeverityInput  ----------
"
"------------------------------------------------------------------------------
"  C_CodeCheckArguments : CodeCheck command line arguments       {{{1
"------------------------------------------------------------------------------
function! C_CodeCheckArguments ()
    if s:C_CodeCheckIsExecutable==0
        let s:C_HlMessage = ' CodeCheck is not executable or not installed! '
    else
        let	prompt	= 'CodeCheck command line arguments for "'.expand("%").'" : '
        if exists("b:C_CodeCheckCmdLineArgs")
            let	b:C_CodeCheckCmdLineArgs= C_Input( prompt, b:C_CodeCheckCmdLineArgs )
        else
            let	b:C_CodeCheckCmdLineArgs= C_Input( prompt , s:C_CodeCheckOptions )
        endif
    endif
endfunction    " ----------  end of function C_CodeCheckArguments ----------
"
"------------------------------------------------------------------------------
"  C_CodeCheck : run CodeCheck       {{{1
"------------------------------------------------------------------------------
function! C_CodeCheck ()
    if s:C_CodeCheckIsExecutable==0
        let s:C_HlMessage = ' CodeCheck is not executable or not installed! '
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
    call s:C_SaveGlobalOption('makeprg')
    exe	"setlocal makeprg=".s:C_CodeCheckExeName
    "
    " match the splint error messages (quickfix commands)
    " ignore any lines that didn't match one of the patterns
    "
    call s:C_SaveGlobalOption('errorformat')
    setlocal errorformat=%f(%l)%m
    "
    let l:arguments  = exists("b:C_CodeCheckCmdLineArgs") ? b:C_CodeCheckCmdLineArgs : ""
    if empty( l:arguments )
        let l:arguments	=	s:C_CodeCheckOptions
    endif
    exe	":make ".l:arguments." ".escape( l:currentbuffer, s:C_FilenameEscChar )
    call s:C_RestoreGlobalOption('errorformat')
    call s:C_RestoreGlobalOption('makeprg')
    exe	":botright cwindow"
    "
    " message in case of success
    "
    if l:currentbuffer == bufname("%")
        let s:C_HlMessage = " CodeCheck --- no warnings for : ".l:currentbuffer
    endif
endfunction    " ----------  end of function C_CodeCheck ----------
"
"------------------------------------------------------------------------------
"  C_Indent : run indent(1)       {{{1
"------------------------------------------------------------------------------
"
function! C_Indent ( )
    if s:C_IndentIsExecutable == 0
        echomsg 'indent is not executable or not installed!'
        return
    endif
    let	l:currentbuffer=expand("%:p")
    if &filetype != "c" && &filetype != "cpp"
        echomsg '"'.l:currentbuffer.'" seems not to be a C/C++ file '
        return
    endif
    if C_Input("indent whole file [y/n/Esc] : ", "y" ) != "y"
        return
    endif
    :update

    exe	":cclose"
    silent exe ":%!indent 2> ".s:C_IndentErrorLog
    redraw!
    call s:C_SaveGlobalOption('errorformat')
    if getfsize( s:C_IndentErrorLog ) > 0
        exe ':edit! '.s:C_IndentErrorLog
        let errorlogbuffer	= bufnr("%")
        exe ':%s/^indent: Standard input/indent: '.escape( l:currentbuffer, '/' ).'/'
        setlocal errorformat=indent:\ %f:%l:%m
        :cbuffer
        exe ':bdelete! '.errorlogbuffer
        exe	':botright cwindow'
    else
        echomsg 'File "'.l:currentbuffer.'" reformatted.'
    endif
    call s:C_RestoreGlobalOption('errorformat')

endfunction    " ----------  end of function C_Indent ----------
"
"------------------------------------------------------------------------------
"  C_HlMessage : indent message     {{{1
"------------------------------------------------------------------------------
function! C_HlMessage ( ... )
    redraw!
    echohl Search
    if a:0 == 0
        echo s:C_HlMessage
    else
        echo a:1
    endif
    echohl None
endfunction    " ----------  end of function C_HlMessage ----------
"
"
function! C_Hardcopy () range
    let outfile = expand("%")
    if empty(outfile)
        let s:C_HlMessage = 'Buffer has no name.'
        call C_HlMessage()
    endif
    let outdir	= getcwd()
    if filewritable(outdir) != 2
        let outdir	= $HOME
    endif
    let outdir	= outdir.'/'
    let old_printheader=&printheader
    exe  ':set printheader='.s:C_Printheader
    " ----- normal mode ----------------
    if a:firstline == a:lastline
        silent exe  'hardcopy > '.outdir.outfile.'.ps'
        echo 'file "'.outfile.'" printed to "'.outdir.outfile.'.ps"'
    endif
    " ----- visual mode / range ----------------
    if a:firstline < a:lastline
        silent exe  a:firstline.','.a:lastline."hardcopy > ".outdir.outfile.".ps"
        echo 'file "'.outfile.'" (lines '.a:firstline.'-'.a:lastline.') printed to "'.outdir.outfile.'.ps"'
    endif
    exe  ':set printheader='.escape( old_printheader, ' %' )
endfunction   " ---------- end of function  C_Hardcopy  ----------
"
"------------------------------------------------------------------------------
"  C_Help : lookup word under the cursor or ask    {{{1
"------------------------------------------------------------------------------
"
let s:C_DocBufferName       = "C_HELP"
let s:C_DocHelpBufferNumber = -1
"
function! C_Help( type )

    let cuc		= getline(".")[col(".") - 1]		" character under the cursor
    let	item	= expand("<cword>")							" word under the cursor
    if empty(cuc) || empty(item) || match( item, cuc ) == -1
        let	item=C_Input('name of the manual page : ', '' )
    endif

    if empty(item)
        return
    endif
    "------------------------------------------------------------------------------
    "  replace buffer content with bash help text
    "------------------------------------------------------------------------------
    "
    " jump to an already open bash help window or create one
    "
    if bufloaded(s:C_DocBufferName) != 0 && bufwinnr(s:C_DocHelpBufferNumber) != -1
        exe bufwinnr(s:C_DocHelpBufferNumber) . "wincmd w"
        " buffer number may have changed, e.g. after a 'save as'
        if bufnr("%") != s:C_DocHelpBufferNumber
            let s:C_DocHelpBufferNumber=bufnr(s:C_OutputBufferName)
            exe ":bn ".s:C_DocHelpBufferNumber
        endif
    else
        exe ":new ".s:C_DocBufferName
        let s:C_DocHelpBufferNumber=bufnr("%")
        setlocal buftype=nofile
        setlocal noswapfile
        setlocal bufhidden=delete
        setlocal filetype=sh		" allows repeated use of <S-F1>
        setlocal syntax=OFF
    endif
    setlocal	modifiable
    "
    if a:type == 'm' 
        "
        " Is there more than one manual ?
        "
        let manpages	= system( s:C_Man.' -k '.item )
        if v:shell_error
            echomsg	"Shell command '".s:C_Man." -k ".item."' failed."
            :close
            return
        endif
        let	catalogs	= split( manpages, '\n', )
        let	manual		= {}
        "
        " Select manuals where the name exactly matches
        "
        for line in catalogs
            if line =~ '^'.item.'\s\+(' 
                let	itempart	= split( line, '\s\+' )
                let	catalog		= itempart[1][1:-2]
                if match( catalog, '.p$' ) == -1
                    let	manual[catalog]	= catalog
                endif
            endif
        endfor
        "
        " Build a selection list if there are more than one manual
        "
        let	catalog	= ""
        if len(keys(manual)) > 1
            for key in keys(manual)
                echo ' '.item.'  '.key
            endfor
            let defaultcatalog	= ''
            if has_key( manual, '3' )
                let defaultcatalog	= '3'
            else
                if has_key( manual, '2' )
                    let defaultcatalog	= '2'
                endif
            endif
            let	catalog	= input( 'select manual section (<Enter> cancels) : ', defaultcatalog )
            if ! has_key( manual, catalog )
                :close
                :redraw
                echomsg	"no appropriate manual section '".catalog."'"
                return
            endif
        endif

        set filetype=man
        silent exe ":%!".s:C_Man." ".catalog." ".item
    endif

    setlocal nomodifiable
endfunction		" ---------- end of function  C_Help  ----------
"
