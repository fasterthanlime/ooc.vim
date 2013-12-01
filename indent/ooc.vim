" Vim indent file
" Inspired by scala.vim - https://github.com/jergason/scala.vim
" Language   : ooc (http://ooc-lang.org/)
" Maintainer : Amos Wenger
" Last Change: 2013 Dec 01

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetOocIndent()

setlocal indentkeys=0{,0},0),!^F,<>>,<CR>

setlocal autoindent shiftwidth=4 tabstop=4 softtabstop=4 expandtab

if exists("*GetOocIndent")
  finish
endif

function! CountParens(line)
  " if in a comment line, ignore parens
  if a:line =~ '^\s*//'
      \ || a:line =~ '^\s*/\*'
      \ || a:line =~ '^\s*\*/'
    return 0
  endif
  let line = substitute(a:line, '"\(.\|\\"\)*"', '', 'g')
  let open = substitute(line, '[^(]', '', 'g')
  let close = substitute(line, '[^)]', '', 'g')
  return strlen(open) - strlen(close)
endfunction

function! GetOocIndent()
  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)
  let prevline = getline(lnum)

  " Add a 'shiftwidth' after lines that start a block
  " If if, for or while end with ), this is a one-line block
  " If val, var, def end with =, this is a one-line block
  if prevline =~ '^\s*\<\(\(else\s\+\)\?if\|for\|while\)\>.*[)]\s*$'
        \ || prevline =~ '^\s*\<\(\(va[lr]\|def\)\>.*[=]\s*$'
        \ || prevline =~ '^\s*\<else\>\s*$'
        \ || prevline =~ '{\s*$'
    let ind = ind + &shiftwidth
  endif

  " If parenthesis are unbalanced, indent or dedent
  let c = CountParens(prevline)
  echo c
  if c > 0
    let ind = ind + &shiftwidth
  elseif c < 0
    let ind = ind - &shiftwidth
  endif
  
  " Dedent after if, for, while and val, var, def without block
  let pprevline = getline(prevnonblank(lnum - 1))
  if pprevline =~ '^\s*\<\(\(else\s\+\)\?if\|for\|while\)\>.*[)]\s*$'
        \ || pprevline =~ '^\s*\<\(\va[lr]\|def\)\>.*[=]\s*$'
        \ || pprevline =~ '^\s*\<else\>\s*$'
    let ind = ind - &shiftwidth
  endif

  " Align 'for' clauses nicely
  if prevline =~ '^\s*\<for\> (.*;\s*$'
    let ind = ind - &shiftwidth + 5
  endif

  " Subtract a 'shiftwidth' on '}'
  let thisline = getline(v:lnum)
  if thisline =~ '^\s*[})]'
    let ind = ind - &shiftwidth
  endif

  return ind
endfunction
