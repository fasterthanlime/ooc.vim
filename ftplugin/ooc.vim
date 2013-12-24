
" error format for errors
set errorformat=%f:%l:%c\ error\ %m

" error format for warnings
set errorformat+=%f:%l:%c\ warning\ %m

" default build command
set makeprg=rock\ -v

" for vim-commentary
set commentstring=\/\/\ %s
