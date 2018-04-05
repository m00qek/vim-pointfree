function! s:close_if_pointfree(winnr)
  if &l:filetype == 'haskell.pointfree'
    silent bdelete!
  endif
endfunction

function! s:nmap(key, func)
  execute 'nnoremap <silent> <buffer> ' . a:key . ' :call ' . a:func . '<CR>'
endfunction


function! pointfree#window#apply(target_window, target_line)
  let l:current_line = getline(a:firstline, a:lastline)

  call pointfree#window#close(a:target_window)
  call setline(a:target_line, l:current_line)
endfunction

function! pointfree#window#close(window)
  silent windo call s:close_if_pointfree(winnr())
  call win_gotoid(a:window)
endfunction

function! pointfree#window#open(current_window, current_line, suggestions)
  execute 'silent botright 10new'
  call setline(1, a:suggestions)

  setlocal readonly nomodifiable
  let &l:filetype = 'haskell.pointfree'
  setlocal syntax=haskell

  let l:parameters = '(' . a:current_window . ', ' . a:current_line . ')'
  call s:nmap('<CR>', 'pointfree#window#apply' . l:parameters)

  let l:parameters = '(' . a:current_window . ')'
  call s:nmap('<Esc>', 'pointfree#window#close' . l:parameters)
endfunction
