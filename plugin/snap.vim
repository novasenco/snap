" Author: Nova Senco
" Last Change: 24 April 2021

" insert a placeholder
inoremap <expr> <plug>(snapSimple) snap#simple()
inoremap <expr> <plug>(snapText) snap#text(input('Reminder: '))

" select next placeholder
inoremap <silent> <plug>(snapNext) <c-g>u<esc>:call snap#snap(1)<cr>
nnoremap <silent> <plug>(snapNext) :<c-u>call snap#snap(1)<cr>
snoremap <silent> <plug>(snapNext) <esc>:call snap#snap(1)<cr>
xnoremap <silent> <plug>(snapNext) <esc>:<c-u>call snap#select(1)<cr>
onoremap <silent> <plug>(snapNext) :<c-u>call snap#select(1, 1)<cr>

" select prev placeholder
inoremap <silent> <plug>(snapPrev) <c-g>u<esc>:call snap#snap(0)<cr>
nnoremap <silent> <plug>(snapPrev) :call snap#snap(0)<cr>
snoremap <silent> <plug>(snapPrev) <esc>:call snap#snap(0)<cr>
xnoremap <silent> <plug>(snapPrev) <esc>:<c-u>call snap#select(0)<cr>
onoremap <silent> <plug>(snapPrev) :<c-u>call snap#select(0, 1)<cr>

" for repeatability
inoremap <silent> <plug>(snapRepeatNext) <c-g>u<esc>:call snap#snap(1, 1)<cr>
nnoremap <silent> <plug>(snapRepeatNext) :<c-u>call snap#snap(1, 1)<cr>
nnoremap <silent> <plug>(snapRepeatPrev) :<c-u>call snap#snap(0, 1)<cr>
nnoremap <silent> <plug>(snapSelectRepeatNext) :call snap#select(1)<cr>
nnoremap <silent> <plug>(snapSelectRepeatPrev) :call snap#select(0)<cr>

