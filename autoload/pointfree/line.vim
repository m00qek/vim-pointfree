function! pointfree#line#coordinates()
  return { 'line': line('.') }
endfunction

function! pointfree#line#apply(pointfree_window, coordinates)
  let l:current_line = getline(a:firstline, a:lastline)

  call pointfree#window#close(a:pointfree_window)

  call setline(a:coordinates.line, l:current_line)
endfunction

function! pointfree#line#apply_command(window, coordinates)
  return "pointfree#line#apply(" . a:window . ", " . string(a:coordinates). ")"
endfunction

function! pointfree#line#expression(coordinates)
  return join(getline(a:firstline, a:lastline), "\n")
endfunction
