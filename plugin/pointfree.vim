function! s:pointfree(expression)
  let l:suggestions = system('pointfree --verbose '.shellescape(a:expression))
  return [a:expression] + split(l:suggestions, "\n")[3:]
endfunction

function! pointfree#apply(target_window, target_line)
  let l:current_line = getline(a:firstline, a:lastline)

  call win_gotoid(a:target_window)
  call setline(a:target_line, l:current_line)

  call pointfree#close()
endfunction

function! s:close_if_pointfree(winnr)
  if &l:filetype == 'haskell.pointfree'
    silent bdelete!
  endif
endfunction

function! pointfree#close()
  silent pclose
  silent windo call s:close_if_pointfree(winnr())
endfunction

function! pointfree#open(current_window, current_line, expression)
  execute '10new'
  call setline(1, s:pointfree(a:expression))

  setlocal readonly nomodifiable
  let &l:filetype = 'haskell.pointfree'
  setlocal syntax=haskell

  execute 'nnoremap <silent> <buffer> <CR> :call pointfree#apply(' . a:current_window . ', ' . a:current_line . ')<CR>'
  execute 'nnoremap <silent> <buffer> <Esc> :call pointfree#close()<CR>'
endfunction


"  let l:expression = join(getline(a:firstline, a:lastline), "\n")


function! pointfree#suggestions(expression)
  let l:current_window = win_getid()
  let l:current_line = line('.')

  call pointfree#open(l:current_window, l:current_line, a:expression)
endfunction

function! pointfree#optmized(expression)
  return s:pointfree(a:expression)[-1]
endfunction
