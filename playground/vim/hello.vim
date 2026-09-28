" Playground vimscript
function! Greet(name) abort
let l:msg='Hello, '.a:name.'!'
return l:msg
endfunction

command! -nargs=1 Greet echo Greet(<q-args>)
echo l:nope
