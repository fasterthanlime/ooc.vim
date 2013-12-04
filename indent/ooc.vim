" Vim indent file
" Language   : ooc (http://ooc-lang.org/)
" Maintainer : Amos Wenger
" Last Change: 2013 Dec 04

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetOocIndent()
setlocal indentkeys=0{,0},0),:,!^F,o,O,e,<>>,<CR>

setlocal autoindent shiftwidth=4 tabstop=4 softtabstop=4 expandtab

if exists("*GetOocIndent")
  finish
endif

" find start of import, returns -1 if we're not in a multi-line import
function! ImportStart(lnum)
  let lnum = a:lnum

  while lnum > 0
    let line = getline(lnum)
    if line =~ ',\s*$'
      if line =~ '^\s*import\s'
        break
      endif
    else
      " not a line ending in a comma, we can't be in a multi-line import
      return 0
    endif

    let lnum = lnum - 1
  endwhile

  return lnum
endfunction

" determine comment state
function! CommentState(lnum)
  let line = getline(a:lnum)

  let synname = synIDattr(synID(a:lnum, strlen(line) - 1, 0), "name")
  if synname == "oocComment"
    " continue
  else
    return 0
  endif

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
  let lnum = a:lnum - 1

  while lnum > 0
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
  let line = substitute(line, '"\(\\"\|[^"]\)*"', '', 'g')

  " get rid of char literals
  let line = substitute(line, "'\\(\\\\'\\|[^']\\)\\{-}'", '', 'g')

  " get rid of single-line comments
  let line = substitute(line, '//.*$', '', 'g')

  " get rid of multi-line comments
  let line = substitute(line, '/\*.*\*/', '', 'g')

  return line
endfunction

function! CountParens(line, ppline)
  if a:line =~ '\\$' && a:ppline =~ '\\$'
    return 0
  endif

  let open = substitute(a:line, '[^(]', '', 'g')
  let close = substitute(a:line, '[^)]', '', 'g')
  return strlen(open) - strlen(close)
endfunction

function! BlockStart(startline)
  let bracecount = 1
  let lnum = a:startline

  while lnum > 1 && bracecount > 0
    let lnum = lnum - 1
    let line = GetStrippedLine(lnum)

    let open = substitute(line, '[^{]', '', 'g')
    let close = substitute(line, '[^}]', '', 'g')
    let diff = strlen(close) - strlen(open)
    let bracecount = bracecount + diff
  endwhile

  return lnum
endfunction

function! IsSingleLine(line)
  let line = substitute(a:line, '\s*$', '', 'g')
  if line =~ '^\s*else\s*$'
    return 1
  endif

  let n = strlen(line) - 1
  let numparens = 0

  while n > 0
    let c = strpart(line, n, 1)

    if c == '('
      let numparens = numparens - 1
    elseif c == ')'
      let numparens = numparens + 1
    endif

    if numparens < 1
      break
    endif
    
    let n = n - 1
  endwhile 

  if numparens == 0
    let rest = strpart(line, 0, n)
    if rest =~ '^\s*\(if\|else\|for\|while\)\s*$'
      return 1
    endif
  endif

  return 0
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

  let llnum = prevnonblank(lnum - 1)
  let ppline = getline(llnum)

  " Add a 'shiftwidth' after lines that start a block
  " If if, for or while end with ), this is a one-line block
  " If val, var, def end with =, this is a one-line block
  if prevline =~ '[{[]\s*$'
    let ind = ind + &shiftwidth
  endif

  " Add a 'shiftwidth' after braceless if/else/for/while
  if prevline =~ '^\s*\(if\|else\|for\|while\).*\()\)\=$'
    if IsSingleLine(prevline) == 1
      let ind = ind + &shiftwidth
    endif
  endif

  " Then don't forget to remove it...
  if ppline =~ '^\s*\(if\|else\|for\|while\).*\()\)\=$'
    if IsSingleLine(ppline) == 1
      let ind = indent(llnum)
    endif
  endif

  " Align case contents correctly
  if prevline =~ '^\s*case.*[=>]\s*$'
    let bnum = BlockStart(v:lnum)
    let ind = indent(bnum) + (&shiftwidth * 2)
  endif

  " Align multi-line imports correctly
  if prevline =~ ',\s*$'
    let inum = ImportStart(lnum)
    if inum == 0
      " not in an import
    else
      " 'import' + space = 7 spaces
      let ind = indent(inum) + 7
    end
  elseif lnum > 1 && getline(lnum - 1) =~ ',\s*$'
    let inum = ImportStart(lnum - 1)
    if inum == 0
      " okay
    else
      let ind = indent(inum)
    endif
  endif

  " If parenthesis are unbalanced, indent or dedent
  let c = CountParens(prevline, ppline)
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
  if thisline =~ '^\s*[\]})]\(\s\|[\]})]\)*'
    let ind = ind - &shiftwidth

    if thisline =~ '^\s*[}]'
      " align match end with match begin
      let bnum = BlockStart(v:lnum)
      if getline(bnum) =~ '^\s*match.*[{]\s*$'
        let ind = indent(bnum)
      endif
    endif
  endif
  
  " Align cases correctly
  if thisline =~ '^\s*case.*[=>]\(\s\|[{]\)*$'
    let bnum = BlockStart(v:lnum)
    if getline(bnum) =~ '^\s*match.*[{]\s*$'
      let ind = indent(bnum) + &shiftwidth
    endif
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
