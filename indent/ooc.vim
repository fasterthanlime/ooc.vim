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

" determine comment state
" return values are:
" 0 - not in a comment
" 1 - in single-line comment
" 2 - in multi-line comment start
" 3 - in multi-line comment end
" 4 - in multi-line comment middle
function! CommentState(lnum)
  let lnum = a:lnum
  let line = getline(lnum)

  if line =~ '^\s*//'
    " single-line comment
    return 1
  elseif line =~ '/\*.*\*/'
    " single-line comment
    return 1
  elseif line =~ '^\s*/\*'
    " multiline-comment start
    return 2
  elseif line =~ '\*/\s*$'
    " multiline-comment end
    return 3
  endif

  let original = line
  let lnum = lnum - 1

  while lnum > 1
    let line = getline(lnum)
    if line =~ '\*/\s*$'
      " found a closing tag before we found an opening tag,
      " hence, we're not in a comment.
      return 0
    elseif line =~ '^\s*/\*'
      " found an opening tag, that's a good sign
      return 4
    endif
      
    let lnum = lnum - 1
  endwhile

  return 0
endfunction

function! GetStrippedLine(lnum)
  " if in a comment line, empty line!
  let cstate = CommentState(a:lnum)
  if cstate > 0
    return ""
  endif

  let line = getline(a:lnum)

  " get rid of strings
  let line = substitute(line, '"\(.\|\\"\)*"', '', 'g')

  " get rid of single-line comments
  let line = substitute(line, '//.*$', '', 'g')

  " get rid of multi-line comments
  let line = substitute(line, '/\*.*\*/', '', 'g')

  return line
endfunction

function! CountParens(line)
  let line = a:line
  let open = substitute(line, '[^(]', '', 'g')
  let close = substitute(line, '[^)]', '', 'g')
  return strlen(open) - strlen(close)
endfunction

function! BlockStart(startline)
  let bracecount = 1
  let lnum = a:startline

  while lnum > 1 && bracecount > 0
    let lnum = lnum - 1

    let line = getline(lnum)

    if line =~ '}\s*$'
      let bracecount = bracecount + 1
    elseif line =~ '{\s*$'
      let bracecount = bracecount - 1
    endif
  endwhile

  return lnum
endfunction

function! MatchStart(startline)
  let lnum = a:startline
  while lnum > 1
    if getline(lnum) =~ '^\s*match.*[{]\s*$'
      break
    endif
    let lnum = lnum - 1
  endwhile

  return lnum
endfunction

function! GetOocIndent()
  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)
  let prevline = GetStrippedLine(lnum)

  " Add a 'shiftwidth' after lines that start a block
  " If if, for or while end with ), this is a one-line block
  " If val, var, def end with =, this is a one-line block
  if prevline =~ '{\s*$'
    let ind = ind + &shiftwidth
  endif

  " Align case contents correctly
  if prevline =~ '^\s*case.*[=>]\s*$'
    let ms = MatchStart(v:lnum)
    let ind = indent(ms) + (&shiftwidth * 2)
  endif

  " If parenthesis are unbalanced, indent or dedent
  let c = CountParens(prevline)
  echom "lnum = " . lnum . ", c = " . c
  if c > 0
    let ind = ind + &shiftwidth
  elseif c < 0
    if prevline =~ '^\s*[)]'
      " will be caught later
    else
      let ind = ind - &shiftwidth
    endif
  endif

  " Subtract a 'shiftwidth' on '}' or ')'
  let thisline = GetStrippedLine(v:lnum)
  if thisline =~ '^\s*[})]'
    echom "v:lnum = " . v:lnum . ", stripped = " . thisline
    let ind = ind - &shiftwidth

    if thisline =~ '^\s*[}]'
      " deindent twice at the end of match blocks
      let ms = MatchStart(v:lnum)
      let bs = BlockStart(v:lnum)
      if ms == bs
        let ind = ind - &shiftwidth
      endif
    endif
  endif
  
  " Align cases correctly
  if thisline =~ '^\s*case.*[=>]\s*$'
    let ms = MatchStart(v:lnum)
    let ind = indent(ms) + &shiftwidth
  endif

  let cs = CommentState(lnum)
  if cs == 2
    " Within a multi-line comment, indent by 1
    let ind = ind + 1
  elseif cs == 3
    " After a multi-line comment, unindent by 1
    let ind = ind - 1
  endif

  return ind
endfunction
