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

function! pointfree#window#apply_sel(target_window, l_start, c_start, l_end, c_end)
  let l:current_line = getline(a:firstline, a:lastline)[0]
  let l:hreg = getreg("h")
  call setreg("h", trim(l:current_line))
  call pointfree#window#close(a:target_window)
  call setpos("'<", [a:target_window, a:l_start, a:c_start])
  call setpos("'>", [a:target_window, a:l_end, a:c_end])
  normal! gv"hp
  call setreg("h", l:hreg)
endfunction

function! pointfree#window#close(window)
  silent windo call s:close_if_pointfree(winnr())
  call win_gotoid(a:window)
endfunction

function! pointfree#window#open(current_window, suggestions, l_start, ...)
  execute 'silent botright 10new'
  call setline(1, a:suggestions)

  setlocal readonly nomodifiable
  let &l:filetype = 'haskell.pointfree'
  setlocal syntax=haskell

  if a:0 == 3
    let l:parameters = '(' . a:current_window . ', ' . a:l_start . ', ' . a:1 . ', ' . a:2 . ', ' . a:3 . ')'
    call s:nmap('<CR>', 'pointfree#window#apply_sel' . l:parameters)
  else
    let l:parameters = '(' . a:current_window . ', ' . a:l_start . ')'
    call s:nmap('<CR>', 'pointfree#window#apply' . l:parameters)
  endif

  let l:parameters = '(' . a:current_window . ')'
  call s:nmap('<Esc>', 'pointfree#window#close' . l:parameters)
endfunction
