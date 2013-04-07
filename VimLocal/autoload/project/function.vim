if exists("g:loaded_auto_common_function")
    finish
endif
let g:loaded_auto_common_function = 1

function! project#function#Hardcopy () range
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
let s:ManDocBufferName       = "MAN_HELP"
let s:ManDocHelpBufferNumber = -1
let s:ManBin = 'man'
"
function! project#function#Help()
    let cuc	= getline(".")[col(".") - 1]		" character under the cursor
    let	item = expand("<cword>")							" word under the cursor
    if empty(cuc) || empty(item) || match( item, cuc ) == -1
        let	item=project#common#Input('name of the manual page : ', '' )
    endif

    if empty(item)
        return
    endif

    if bufloaded(s:ManDocBufferName) != 0 && bufwinnr(s:ManDocHelpBufferNumber) != -1
        exe bufwinnr(s:ManDocHelpBufferNumber) . "wincmd w"
        " buffer number may have changed, e.g. after a 'save as'
        if bufnr("%") != s:ManDocHelpBufferNumber
            let s:ManDocHelpBufferNumber=bufnr(s:C_OutputBufferName)
            exe ":bn ".s:ManDocHelpBufferNumber
        endif
    else
        exe ":new ".s:ManDocBufferName
        let s:ManDocHelpBufferNumber=bufnr("%")
        setlocal buftype=nofile
        setlocal noswapfile
        setlocal bufhidden=delete
        setlocal filetype=sh		" allows repeated use of <S-F1>
        setlocal syntax=OFF
        setlocal nonumber
    endif
    setlocal modifiable
        let manpages	= system( s:ManBin.' -k '.item )
        if v:shell_error
            echomsg	"Shell command '".s:ManBin." -k ".item."' failed."
            :close
            return
        endif
        let	catalogs	= split( manpages, '\n', )
        let	manual		= {}
        
        for line in catalogs
            if line =~ '^'.item.'\s\+(' 
                let	itempart	= split( line, '\s\+' )
                let	catalog		= itempart[1][1:-2]
                if match( catalog, '.p$' ) == -1
                    let	manual[catalog]	= catalog
                endif
            endif
        endfor

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
        silent exe ":%!".s:ManBin." ".catalog." ".item
    setlocal nomodifiable
endfunction
"
