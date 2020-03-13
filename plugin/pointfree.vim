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
    call pointfree#window#open(l:current_window, l:suggestions, l:current_line)
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

function! pointfree#selection()
  let l:expression = s:get_visual_selection()
  let l:current_window = win_getid()

  let [l:success, l:suggestions] = s:pointfree(l:expression)

  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]

  if l:success
    call pointfree#window#open(l:current_window, l:suggestions, line_start, column_start, line_end, column_end)
    return
  endif

  echo l:suggestions
endfunction

" credit https://stackoverflow.com/a/6271254
function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction
