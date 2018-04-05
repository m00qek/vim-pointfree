function! s:pointfree(expression)
  let l:suggestions = system('pointfree --verbose '.shellescape(a:expression))
  return [a:expression] + split(l:suggestions, "\n")[3:]
endfunction

"  let l:expression = join(getline(a:firstline, a:lastline), "\n")


function! pointfree#suggestions(expression)
  let l:current_window = win_getid()
  let l:current_line = line('.')

  let l:suggestions = s:pointfree(a:expression)
  call pointfree#window#open(l:current_window, l:current_line, l:suggestions)
endfunction

function! pointfree#optmized(expression)
  return s:pointfree(a:expression)[-1]
endfunction
