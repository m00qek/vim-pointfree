function! s:pointfree(expression)
  let l:suggestions = system('pointfree --verbose '.shellescape(a:expression))
  let l:suggestions = split(l:suggestions, "\n")

  if v:shell_error == 0
    return [1, insert(l:suggestions[3:], a:expression)]
  endif

  return [0, "Sorry, I can't pointfree your expression :("]
endfunction


function! pointfree#suggestions()
  let l:expression = join(getline(a:firstline, a:lastline), "\n")
  let l:current_window = win_getid()
  let l:current_line = line('.')

  let [l:success, l:suggestions] = s:pointfree(l:expression)

  if l:success
    call pointfree#window#open(l:current_window, l:current_line, l:suggestions)
    return
  endif

  echo l:suggestions
endfunction

function! pointfree#optmized(expression)
  let [l:success, l:suggestions] = s:pointfree(a:expression)

  if l:success
    echo l:suggestions[-1]
    return
  endif

  echo l:suggestions
endfunction

