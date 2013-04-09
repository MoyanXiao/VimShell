if exists("g:loaded_auto_language_c")
    finish
endif
let g:loaded_auto_language_c = 1

let s:KeyListPath = '~/.vim/wordlists/'

function language#c#LoadKeyList()
    for file in split(globpath("~/.vim/wordlists/", "*"),"\n")
        exe "setlocal dictionary+=".file
    endfor
endfunction

let s:ScriptIdentifier = "INDENTY_C_LANGUAGE"
let s:C_LineEndCommColDefault = 49

let	s:c_cppcomment= '\(\/\*.\{-}\*\/\|\/\/.*$\)'


function! language#c#AdjustLineEndComm() range
    "
    if !exists("b:C_LineEndCommentColumn")
        let	b:C_LineEndCommentColumn	= s:C_LineEndCommColDefault
    endif

    let save_cursor = getpos(".")

    call project#common#SaveOptions(s:ScriptIdentifier,['expandtab'],'')
    exe	":set expandtab"

    let	linenumber	= a:firstline
    exe ":".a:firstline

    while linenumber <= a:lastline
        let	line= getline(".")

        if  match( line, '^\s*'.s:c_cppcomment ) < 0 &&  match( line, s:c_cppcomment ) > 0
            let	idx1 = -1
            let	idx2 = -1
            let	commentstart= -2
            let	commentend	= 0
            while commentstart < idx2 && idx2 < commentend
                let start = commentend
                let idx2 = match( line, s:c_cppcomment, start )
                let commentstart= match   ( line, '"[^"]\+"', start )
                let commentend	= matchend( line, '"[^"]\+"', start )
            endwhile
            let idx1	= 1 + match( line, '\s*'.s:c_cppcomment, start )
            let idx2	= 1 + idx2
            call setpos(".", [ 0, linenumber, idx1, 0 ] )
            let vpos1	= virtcol(".")
            call setpos(".", [ 0, linenumber, idx2, 0 ] )
            let vpos2	= virtcol(".")

            if   ! (   vpos2 == b:C_LineEndCommentColumn
                        \	|| vpos1 > b:C_LineEndCommentColumn
                        \	|| idx2  == 0 )
                exe ":.,.retab"
                " insert some spaces
                if vpos2 < b:C_LineEndCommentColumn
                    let	diff	= b:C_LineEndCommentColumn-vpos2
                    call setpos(".", [ 0, linenumber, vpos2, 0 ] )
                    let	@"	= ' '
                    exe "normal	".diff."P"
                endif
                " remove some spaces
                if vpos1 < b:C_LineEndCommentColumn && vpos2 > b:C_LineEndCommentColumn
                    let	diff	= vpos2 - b:C_LineEndCommentColumn
                    call setpos(".", [ 0, linenumber, b:C_LineEndCommentColumn, 0 ] )
                    exe "normal	".diff."x"
                endif

            endif
        endif
        let linenumber=linenumber+1
        normal j
    endwhile
    " restore tab expansion settings and cursor position
    call project#common#RestoreOptions(s:ScriptIdentifier, [])
    call setpos('.', save_cursor)
endfunction

function! language#c#GetLineEndCommCol ()
    let actcol	= virtcol(".")
    if actcol+1 == virtcol("$")
        let	b:C_LineEndCommentColumn = ''
        while match( b:C_LineEndCommentColumn, '^\s*\d\+\s*$' ) < 0
            let b:C_LineEndCommentColumn = project#common#Input( 'start line-end comment at virtual column : ', actcol, '' )
        endwhile
    else
        let	b:C_LineEndCommentColumn = virtcol(".")
    endif
    echomsg "line end comments will start at column  ".b:C_LineEndCommentColumn
endfunction

"" TODO finish this function
function! language#c#EndOfLineComment() range
    if !exists("b:C_LineEndCommentColumn")
        let	b:C_LineEndCommentColumn	= s:C_LineEndCommColDefault
    endif
    " ----- trim whitespaces -----
    exe a:firstline.','.a:lastline.'s/\s*$//'

    for line in range( a:lastline, a:firstline, -1 )
        let linelength	= virtcol( [line, "$"] ) - 1
        let	diff				= 1
        if linelength < b:C_LineEndCommentColumn
            let diff	= b:C_LineEndCommentColumn -1 -linelength
        endif
        "exe "normal ".diff."A "
        "call mmtemplates#core#InsertTemplate(g:C_Templates, 'Comments.end-of-line-comment')
        if line > a:firstline
            normal k
        endif
    endfor
endfunction

let s:C_If0_Counter = 0 
let s:C_If0_Txt = "If0Label_"   
let s:C_Com1                    = '/*'     " C-style : comment start
let s:C_Com2                    = '*/'     " C-style : comment end

function! language#c#PPIf0(mode) range
    "
    let	s:C_If0_Counter	= 0
    let	save_line = line(".")
    let	actual_line = 0
    "
    normal gg
    while actual_line < search( s:C_If0_Txt."\\d\\+" )
        let actual_line	= line(".")
        let actual_opt  = matchstr( getline(actual_line), s:C_If0_Txt."\\d\\+" )
        let actual_opt  = strpart( actual_opt, strlen(s:C_If0_Txt),strlen(actual_opt)-strlen(s:C_If0_Txt))
        if s:C_If0_Counter < actual_opt
            let	s:C_If0_Counter = actual_opt
        endif
    endwhile
    let	s:C_If0_Counter = s:C_If0_Counter+1
    silent exe ":".save_line
    "
    if a:mode=='a'
        let zz="\n#if  0     ".s:C_Com1." ----- #if 0 : ".s:C_If0_Txt.s:C_If0_Counter." ----- ".s:C_Com2."\n"
        let zz= zz."\n#endif     ".s:C_Com1." ----- #if 0 : ".s:C_If0_Txt.s:C_If0_Counter." ----- ".s:C_Com2."\n\n"
        put =zz
        normal 2k
        call feedkeys("i\t")
    endif

    if a:mode=='v'
        let	pos1 = line("'<")
        let	pos2 = line("'>")
        let zz = "#endif     ".s:C_Com1." ----- #if 0 : ".s:C_If0_Txt.s:C_If0_Counter." ----- ".s:C_Com2."\n\n"
        exe ":".pos2."put =zz"
        let zz = "\n#if  0     ".s:C_Com1." ----- #if 0 : ".s:C_If0_Txt.s:C_If0_Counter." ----- ".s:C_Com2."\n"
        exe ":".pos1."put! =zz"
        "
        if  &foldenable && foldclosed(".")
            normal zv
        endif
    endif

endfunction

function! language#c#PPIf0Remove ()
    if  &foldenable && foldclosed(".")
        normal zv
    endif
    let frstline = searchpair( '^\s*#if\s\+0', '', '^\s*#endif\>.\+\<If0Label_', 'bn' )
    if frstline<=0
        echohl WarningMsg | echo 'no  #if 0 ... #endif  found or cursor not inside such a directive'| echohl None
        return
    endif
    let lastline	= searchpair( '^\s*#if\s\+0', '', '^\s*#endif\>.\+\<If0Label_', 'n' )
    if lastline<=0
        echohl WarningMsg | echo 'no  #if 0 ... #endif  found or cursor not inside such a directive'| echohl None
        return
    endif
    let actualnumber1  = matchstr( getline(frstline), s:C_If0_Txt."\\d\\+" )
    let actualnumber2  = matchstr( getline(lastline), s:C_If0_Txt."\\d\\+" )
    if actualnumber1 != actualnumber2
        echohl WarningMsg | echo 'lines '.frstline.', '.lastline.': comment tags do not match'| echohl None
        return
    endif

    silent exe ':'.lastline.','.lastline.'d'
    silent exe ':'.frstline.','.frstline.'d'

endfunction
"
let s:C_Prototype        = []
let s:C_PrototypeShow    = []
let s:C_PrototypeCounter = 0
let s:C_CComment         = '\/\*.\{-}\*\/\s*'		" C comment with trailing whitespaces
"  '.\{-}'  any character, non-greedy
let s:C_CppComment       = '\/\/.*$'						" C++ comment
"
"------------------------------------------------------------------------------
" language#c#ProtoPick: pick up a method prototype (normal/visual)       {{{1
"  type : 'function', 'method'
"------------------------------------------------------------------------------
function! language#c#ProtoPick( type ) range
    "
    " remove C/C++-comments, leading and trailing whitespaces, squeeze whitespaces
    "
    let prototyp   = ''
    for linenumber in range( a:firstline, a:lastline )
        let newline			= getline(linenumber)
        let newline 	  = substitute( newline, s:C_CppComment, "", "" ) " remove C++ comment
        let prototyp		= prototyp." ".newline
    endfor
    "
    let prototyp  = substitute( prototyp, '^\s\+', "", "" )					" remove leading whitespaces
    let prototyp  = substitute( prototyp, s:C_CComment, "", "g" )		" remove (multiline) C comments
    let prototyp  = substitute( prototyp, '\s\+', " ", "g" )				" squeeze whitespaces
    let prototyp  = substitute( prototyp, '\s\+$', "", "" )					" remove trailing whitespaces
    "
    " prototype for  methods
    "
    if a:type == 'method'
        "
        " remove template keyword
        "
        let prototyp  = substitute( prototyp, '^template\s*<\s*class \w\+\s*>\s*', "", "" )
        "
        let idx     = stridx( prototyp, '(' )								    		" start of the parameter list
        let head    = strpart( prototyp, 0, idx )
        let parlist = strpart( prototyp, idx )
        "
        " remove the scope resolution operator
        "
        let	template_id	= '\h\w*\s*\(<[^>]\+>\)\?'
        let	rgx2				= '\('.template_id.'\s*::\s*\)*\([~]\?\h\w*\|operator.\+\)\s*$'
        let idx 				= match( head, rgx2 )								    		" start of the function name
        let returntype	= strpart( head, 0, idx )
        let fctname	  	= strpart( head, idx )

        let resret	= matchstr( returntype, '\('.template_id.'\s*::\s*\)*'.template_id )
        let resret	= substitute( resret, '\s\+', '', 'g' )

        let resfct	= matchstr( fctname   , '\('.template_id.'\s*::\s*\)*'.template_id )
        let resfct	= substitute( resfct, '\s\+', '', 'g' )

        if  !empty(resret) && match( resfct, resret.'$' ) >= 0
            "
            " remove scope resolution from the return type (keep 'std::')
            " 
            let returntype	= substitute( returntype, '<\s*\w\+\s*>', '', 'g' )
            let returntype 	= substitute( returntype, '\<std\s*::', 'std##', 'g' )	" remove the scope res. operator
            let returntype 	= substitute( returntype, '\<\h\w*\s*::', '', 'g' )			" remove the scope res. operator
            let returntype 	= substitute( returntype, '\<std##', 'std::', 'g' )			" remove the scope res. operator
        endif

        let fctname		  = substitute( fctname, '<\s*\w\+\s*>', "", "g" )
        let fctname   	= substitute( fctname, '\<std\s*::', 'std##', 'g' )	" remove the scope res. operator
        let fctname   	= substitute( fctname, '\<\h\w*\s*::', '', 'g' )		" remove the scope res. operator
        let fctname   	= substitute( fctname, '\<std##', 'std::', 'g' )		" remove the scope res. operator

        let	prototyp	= returntype.fctname.parlist
        "
        if empty(fctname) || empty(parlist)
            echon 'No prototype saved. Wrong selection ?'
            return
        endif
    endif
    "
    " remove trailing parts of the function body; add semicolon
    "
    let prototyp	= substitute( prototyp, '\s*{.*$', "", "" )
    let prototyp	= prototyp.";\n"

    "
    " bookkeeping
    "
    let s:C_PrototypeCounter += 1
    let s:C_Prototype        += [prototyp]
    let s:C_PrototypeShow    += ["(".s:C_PrototypeCounter.") ".bufname("%")." #  ".prototyp]
    "
    echon	s:C_PrototypeCounter.' prototype'
    if s:C_PrototypeCounter > 1
        echon	's'
    endif
    "
endfunction 

function! language#c#ProtoInsert ()
    "
    " use internal formatting to avoid conficts when using == below
    let	equalprg_save	= &equalprg
    set equalprg=
    "
    if s:C_PrototypeCounter > 0
        for protytype in s:C_Prototype
            put =protytype
        endfor
        let	lines	= s:C_PrototypeCounter	- 1
        silent exe "normal =".lines."-"
        call language#c#ProtoClear()
    else
        echo "currently no prototypes available"
    endif
    "
    " restore formatter programm
    let &equalprg	= equalprg_save
    "
endfunction

function! language#c#ProtoClear ()
    if s:C_PrototypeCounter > 0
        let s:C_Prototype        = []
        let s:C_PrototypeShow    = []
        if s:C_PrototypeCounter == 1
            echo	s:C_PrototypeCounter.' prototype deleted'
        else
            echo	s:C_PrototypeCounter.' prototypes deleted'
        endif
        let s:C_PrototypeCounter = 0
    else
        echo "currently no prototypes available"
    endif
endfunction

function! language#c#ProtoShow ()
    if s:C_PrototypeCounter > 0
        for protytype in s:C_PrototypeShow
            echo protytype
        endfor
    else
        echo "currently no prototypes available"
    endif
endfunction
"
