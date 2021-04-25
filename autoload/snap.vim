" Author: Nova Senco
" Last Change: 24 April 2021

let s:verbosity = 1           " default verbosity
let s:text = ['{@', ':', '}'] " default text

function! s:error(msg)
  if get(g:, 'snap#verbosity', s:verbosity) < 1
    return
  endif
  echohl ErrorMsg
  unsilent echom a:msg
  echohl NONE
endfunction

function! s:warn(msg)
  if get(g:, 'snap#verbosity', s:verbosity) < 2
    return
  endif
  echohl WarningMsg
  unsilent echom a:msg
  echohl NONE
endfunction

function! s:text()
  let text = get(b:, 'snap_text')
  if type(text) is v:t_list && len(text) > 2
    return text
  endif
  let text = get(g:, 'snap#text')
  if type(text) is v:t_list && len(text) > 2
    return text
  endif
  return s:text
endfunction

" get the simple placeholder
function! snap#simple()
  let text = s:text()
  return text[0]..text[2]
endfunction

" get the placeholder with reminder {text}
function! snap#text(text)
  let text = s:text()
  return text[0]..text[1]..a:text..text[2]
endfunction

" get regular expression that matches the for snap
function! snap#regex()
  let text = s:text()
  return printf('\m%s\%%(%s\(.\{-}\)\)\?%s', escape(text[0], '^$.*~\[]'), escape(text[1], '^$.*~\[]'), escape(text[2], '^$.*~\[]'))
endfunction

" snap to next placeholder
function! snap#snap(forwards, ...)
  let regq = getreg('"')
  let reg0 = getreg('0')
  let savs = [@", @0]
  if snap#select(a:forwards)
    normal! ygv"_d
    let eol = col("'[") == col('$')
    if a:0
      execute 'normal!' '".'.'Pp'[eol]
    else
      startinsert
      call setpos('.', getpos("'["))
      call setreg('0', substitute(getreg('"'), snap#regex(), '\1', ''))
      if !empty(@0)
        call s:warn('@0 set to "'.escape(@0, '"\').'"')
        if get(b:, 'snap_select', get(g:, 'snap#select'))
          execute 'normal!' '"0'..'Pp'[eol].."v`[o`]\<c-g>"
          execute 'normal!' 'ai'[eol].."\<c-r>0\<esc>v`[o`]h\<c-g>"
        endif
        let reg0 = getreg('0')
      endif
    endif
  endif
  silent! call repeat#set(printf("\<plug>(snapRepeat%s)", a:forwards ? 'Next' : 'Prev'))
  call setreg('"', regq)
  call setreg('0', reg0)
endfunction

" visually select next placeholder; return 1 if found else 0
function! snap#select(forwards)
  let pat = snap#regex()
  if !a:forwards && !search(pat, 'b') || !search(pat, a:forwards ? 'cw' : 'cwb')
    call s:error('No placeholder found!')
    return 0
  endif
  normal! v
  call search(pat, 'e')
  if v:operator == 'g@'
    silent! call repeat#set(printf("g@\<plug>(snapSelectRepeat%s)", a:forwards ? 'Next' : 'Prev'))
  endif
  return 1
endfunction

