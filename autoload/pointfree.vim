function! s:pointfree(expression)
  let l:suggestions = system('pointfree --verbose '.shellescape(a:expression))
  let l:suggestions = split(l:suggestions, "\n")[3:]

  if v:shell_error == 0
    return [v:true, insert(l:suggestions, a:expression)]
  endif

  return [v:false, "Sorry, I couldn't pointfree your expression :("]
endfunction

function! s:pointfree_window(Expression, Writer, coordinates)
  let l:current_window = win_getid()
  let [l:success, l:suggestions] = s:pointfree(a:Expression(a:coordinates))

  if l:success
    call pointfree#window#open(l:current_window,
    \                          l:suggestions,
    \                          a:Writer(l:current_window, a:coordinates))
  else
    echoerr l:suggestions
  endif
endfunction

function! pointfree#optmized(expression)
  let [l:success, l:suggestions] = s:pointfree(a:expression)

  if l:success
    return l:suggestions[-1]
  else
    echoerr l:suggestions
  endif
endfunction

function! pointfree#selection()
  call s:pointfree_window(function('pointfree#visual#expression'),
  \                       function('pointfree#visual#apply_command'),
  \                       pointfree#visual#coordinates())
endfunction

function! pointfree#suggestions()
  call s:pointfree_window(function('pointfree#line#expression'),
  \                       function('pointfree#line#apply_command'),
  \                       pointfree#line#coordinates())
endfunction
