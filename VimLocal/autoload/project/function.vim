if exists("g:loaded_auto_common_function")
    finish
endif
let g:loaded_auto_common_function = 1

"------------------------------------------------------------------------------
"  insert date and time     {{{1
"------------------------------------------------------------------------------
function! C_InsertDateAndTime ( format )
    if &foldenable && foldclosed(".") >= 0
        echohl WarningMsg | echomsg s:MsgInsNotAvail  | echohl None
        return ""
    endif
    if col(".") > 1
        exe 'normal a'.C_DateAndTime(a:format)
    else
        exe 'normal i'.C_DateAndTime(a:format)
    endif
endfunction    " ----------  end of function C_InsertDateAndTime  ----------

"------------------------------------------------------------------------------
"  generate date and time     {{{1
"------------------------------------------------------------------------------
function! C_DateAndTime ( format )
    if a:format == 'd'
        return strftime( s:C_FormatDate )
    elseif a:format == 't'
        return strftime( s:C_FormatTime )
    elseif a:format == 'dt'
        return strftime( s:C_FormatDate ).' '.strftime( s:C_FormatTime )
    elseif a:format == 'y'
        return strftime( s:C_FormatYear )
    endif
endfunction    " ----------  end of function C_DateAndTime  ----------


