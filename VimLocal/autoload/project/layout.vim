if exists("g:loaded_auto_project_layout")
    finish
endif
let g:loaded_auto_project_layout=1

aug layout
    au!
    au TabEnter * call project#layout#LayoutTabEnter()
    au TabLeave * call project#layout#LayoutClose()
aug END

function! project#layout#LayoutToggle()
    if IsWinManagerVisible()
        let t:winlayout=[]
        call project#layout#LayoutClose()
    else
        let t:winlayout=[]
        call project#layout#LayoutOpen()
    endif
endfunction

function! project#layout#LayoutTabEnter()
    if exists("t:winlayout") && len(t:winlayout)>0
        call project#layout#LayoutToggle()
    endif
endfunction

function! project#layout#LayoutClose()
    exec "NERDTreeClose"
    exec "WMClose"
endfunction

function! project#layout#LayoutOpen()
    if bufname("%") == ''
        let curbufname='EMPTY'
    else
        let curbufname=bufname("%")
    endif
    call add(t:winlayout, {curbufname : winnr()+1})
    let fd=&fdm
    let nu=&nu
    let wrap=&wrap
    let &fdm='manual'
    let &nu=0
    let &wrap=0
    exec "NERDTree"
    exec "WManager"
    let &fdm=fd
    let &nu=nu
    let &wrap=wrap
    call add(t:winlayout, {bufname(winbufnr(1)) : 1})
    call add(t:winlayout, {bufname(winbufnr(winnr("$")-1)) : winnr("$")-1})
    call add(t:winlayout, {bufname(winbufnr(winnr("$"))) : winnr("$")})
    exec t:winlayout[0][keys(t:winlayout[0])[0]]. "wincmd w"
endfunction

function! project#layout#LayoutMoveTo(idx)
    if !exists("t:winlayout")
        return
    endif

    if len(t:winlayout) == 0 || a:idx > 3
        return
    endif 

    let curwin = winnr()
    if has_key(t:winlayout[a:idx], bufname("%"))
        return
    endif

    if has_key(t:winlayout[1], bufname("%")) ||
                \ has_key(t:winlayout[2], bufname("%")) ||
                \ has_key(t:winlayout[3], bufname("%"))
    else
        let t:winlayout[0][bufname("%")]=curwin
    endif
    let dest =t:winlayout[a:idx][keys(t:winlayout[a:idx])[0]]
    if !has_key(t:winlayout[a:idx], bufname(winbufnr(dest)))
        let idx=1
        while idx < winnr("$")
            if has_key(t:winlayout[a:idx], bufname(winbufnr(idx)))
                let dest = idx
                let t:winlayout[a:idx][bufname(winbufnr(idx))]=idx
                exec dest."wincmd w"
                break
            endif
            let idx=idx+1
        endwhile
    else
        exec dest."wincmd w"
    endif
endfunction

function! project#layout#LayoutMoveBack()
    if !exists("t:winlayout")
        return
    endif

    if len(t:winlayout) == 0
        return
    endif 

    if bufname("%") == ''
        return
    endif

    if has_key(t:winlayout[1], bufname("%")) ||
                \ has_key(t:winlayout[2], bufname("%")) ||
                \ has_key(t:winlayout[3], bufname("%"))
        exec t:winlayout[0][keys(t:winlayout[0])[0]]."wincmd w"
    endif
endfunction



