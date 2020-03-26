function! pointfree#visual#coordinates()
  let [start_line, start_column] = getpos("'<")[1:2]
  let [end_line, end_column] = getpos("'>")[1:2]

  return { 'start_line': start_line,
         \ 'start_column': start_column,
         \ 'end_line': end_line,
         \ 'end_column': end_column
         \ }
endfunction

function! pointfree#visual#apply(pointfree_window, coordinates)
  let l:current_line = getline(a:firstline, a:lastline)[0]
  let l:hreg = getreg("h")
  call setreg("h", trim(l:current_line))

  call pointfree#window#close(a:pointfree_window)

  call setpos("'<", [ a:pointfree_window
  \                 , a:coordinates.start_line
  \                 , a:coordinates.start_column ])

  call setpos("'>", [ a:pointfree_window
  \                 , a:coordinates.end_line
  \                 , a:coordinates.end_column ])

  normal! gv"hp
  call setreg("h", l:hreg)
endfunction

function! pointfree#visual#apply_command(window, coordinates)
  return "pointfree#visual#apply(" . a:window . ", " . string(a:coordinates). ")"
endfunction

function! pointfree#visual#expression(coordinates)
  let lines = getline(a:coordinates.start_line, a:coordinates.end_line)
  if len(lines) == 0
      return ''
  endif

  let l:start = a:coordinates.start_column - 1
  let l:end = a:coordinates.end_column - (&selection == 'inclusive' ? 1 : 2)

  let lines[0] = lines[0][l:start :]
  let lines[-1] = lines[-1][: l:end]

  return join(lines, "\n")
endfunction
