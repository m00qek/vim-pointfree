function! s:close_if_pointfree(winnr)
  if &l:filetype == 'haskell.pointfree'
    silent bdelete!
  endif
endfunction

function! s:nmap(key, func)
  execute 'nnoremap <silent> <buffer> ' . a:key . ' :call ' . a:func . '<CR>'
endfunction

function! pointfree#window#close(window)
  silent windo call s:close_if_pointfree(winnr())
  call win_gotoid(a:window)
endfunction

function! pointfree#window#open(current_window, suggestions, writer)
  execute 'silent botright 10new'
  call setline(1, a:suggestions)

  setlocal readonly nomodifiable
  setlocal nonumber
  let &l:filetype = 'haskell.pointfree'
  setlocal syntax=haskell

  call s:nmap('<CR>' , a:writer)
  call s:nmap('<Esc>', 'pointfree#window#close(' . a:current_window . ")")
endfunction
