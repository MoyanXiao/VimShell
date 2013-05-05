" range_date.vim: some auxiliary functions to work with ranges and dates
" @Author:      <bastian at mathes dot jp>
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2008-03-24

" Range_int(start, stop[, step[, format]])
if &cp || project#workspaceInfo#pluginHeader("RangeData", expand("<sfile>:p"))
    finish
endif

function! Range_int(start,stop,...)
	let l:step = a:0 >= 1 ? a:1 : 1
	let l:format = a:0 >= 2 ? a:2 : "%d"
	let l:counter = a:start
	let l:erg = []
	while l:counter <= a:stop
		call add(l:erg,printf(l:format,l:counter))
		let l:counter = l:counter + l:step
	endwhile
	return l:erg
endfunction

" range by ascii value
function! Range_char(start,stop)
	let l:counter = char2nr(a:start)
	let l:erg = []
	while l:counter <= char2nr(a:stop)
		call add(l:erg,nr2char(l:counter))
		let l:counter = l:counter + 1 
	endwhile
	return l:erg
endfunction

" Range_month(start, stop[, format])
function! Range_month(start,stop,...)
	let l:month = strpart(a:start,strlen(a:start)-2) + 0
	let l:year = strpart(a:start,0,strlen(a:start)-2) + 0
	let l:month_stop = strpart(a:stop,strlen(a:stop)-2) + 0
	let l:year_stop = strpart(a:stop,0,strlen(a:stop)-2) + 0
	let l:format = a:0 >=1 ? a:1 : "YYYYMM"
	let l:erg = []
	while l:year < l:year_stop || l:month <= l:month_stop
		call add(l:erg,Format_date(l:year.printf("%02d",l:month),l:format))
		let l:month = l:month == 12 ? 1 : l:month + 1
		let l:year = l:month == 1 ? l:year + 1 : l:year
	endwhile
	return l:erg
endfunction

" Range_date(start,stop[, format])
function! Range_date(start,stop,...)
	let l:jd = Gd2jd(a:start)
	let l:jd_stop = Gd2jd(a:stop)
	let l:format = a:0 >= 1 ? a:1 : "YYYYMMDD"
	let l:erg = []
	while l:jd <= l:jd_stop
		call add(l:erg,Format_date(Jd2gd(l:jd),l:format))
		let l:jd = l:jd + 1
	endwhile
	return l:erg
endfunction

" convert gregorian date (YYYYMMDD) to julian data (integer)
function! Gd2jd(gregorian)
	let l:y=strpart(a:gregorian,0,4)
	let l:m=strpart(a:gregorian,4,2)
	let l:d=strpart(a:gregorian,6,2)
	return l:d-32075+1461*(l:y+4800+(l:m-14)/12)/4+367*(l:m-2-(l:m-14)/12*12)/12-3*((l:y+4900+(l:m-14)/12)/100)/4
endfunction

" convert julian date (integer) to gregorian date (YYYYMMDD)
function! Jd2gd(julian)
	let l:L    = a:julian+68569
	let l:N    = 4*l:L/146097
	let l:L    = l:L-(146097*l:N+3)/4
	let l:I    = 4000*(l:L+1)/1461001
	let l:L    = l:L-1461*l:I/4+31
	let l:J    = 80*l:L/2447
	let l:DD   = l:L-2447*l:J/80
	let l:L    = l:J/11
	let l:MM   = l:J+2-12*l:L
	let l:YYYY = 100*(l:N-49)+l:I+l:L
	return l:YYYY.printf('%02d',l:MM).printf('%02d',l:DD)
endfunction

" date=YYYY[MM[DD[HH[MI[SS]]]]]]
" format=any string containing the characters above
function! Format_date(date,format)
	let l:erg = a:format
	if strlen(a:date) >= 4
		let l:erg = substitute(l:erg,'YYYY',strpart(a:date,0,4),'')
		let l:erg = substitute(l:erg,'YY',strpart(a:date,2,2),'')
		if strlen(a:date) >= 6
			let l:erg = substitute(l:erg,'MM',strpart(a:date,4,2),'')
			if strlen(a:date) >= 8
				let l:erg = substitute(l:erg,'DD',strpart(a:date,6,2),'')
				if strlen(a:date) >= 10
					let l:erg = substitute(l:erg,'HH',strpart(a:date,8,2),'')
					if strlen(a:date) >= 12
						let l:erg = substitute(l:erg,'MI',strpart(a:date,10,2),'')
						if strlen(a:date) >= 14
							let l:erg = substitute(l:erg,'SS',strpart(a:date,12,2),'')
						endif
					endif
				endif	
			endif
		endif
	endif
	return l:erg
endfunction
