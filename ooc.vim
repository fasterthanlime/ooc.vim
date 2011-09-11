" Vim syntax file
" Language: ooc
" Maintainer: Curtis McEnroe
" Latest Revision: 11 September 2011

if exists("b:current_syntax")
  finish
endif

syn keyword oocStatement break return continue
syn keyword oocLabel case
syn keyword oocConditional if else match
syn keyword oocRepeat while for do
syn keyword oocExceptions try catch finally
syn keyword oocInclude import use

syn keyword oocBoolean true false
syn keyword oocConstant null

syn keyword oocTodo TODO FIXME

"""

hi def link oocStatement Statement
hi def link oocLabel Label
hi def link oocConditional Conditional
hi def link oocRepeat Repeat
hi def link oocExceptions Exception
hi def link oocInclude Include
hi def link oocBoolean Boolean
hi def link oocConstant Constant
hi def link oocTodo Todo

let b:current_syntax = "ooc"
