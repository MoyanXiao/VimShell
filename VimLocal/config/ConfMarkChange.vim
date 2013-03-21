" This is the config file of BufExplorer plugin
" To be loaded by .vimrc
"
"
" Enable ShowMarks
let showmarks_enable = 0
" Show which marks
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
" Ignore help, quickfix, non-modifiable buffers
let showmarks_ignore_type = "hqm"
" Hilight lower & upper marks
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 1

nmap <silent> <leader>mk :MarksBrowser<cr>
