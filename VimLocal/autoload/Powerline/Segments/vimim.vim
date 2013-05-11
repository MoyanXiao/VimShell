" @TODO: 当为中文输入状态时，红色高亮显示
" @TODO: 只在插入/替换/选择模式时显示状态栏信息
" @TODO: buffer specific
" @TODO: 只有为中文状态时显示？
let g:Powerline#Segments#vimim#segments = Pl#Segment#Init(['vimim',
	\ Pl#Segment#Create('statusline', '%{&l:iminsert==1 ? g:vimim : "英"}')
\ ])
