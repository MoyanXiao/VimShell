let g:SuperTabDefaultCompletionType = "context"
let g:acp_behaviorSnipmateLength = 1

" Move a line of text 
nmap ;mj mz:m+<cr>`z
nmap ;mk mz:m-2<cr>`z
vmap ;mj :m'>+<cr>`<my`>mzgv`yo`z
vmap ;mk :m'<-2<cr>`>my`<mzgv`yo`z
