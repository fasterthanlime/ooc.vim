" Vim syntax file
" Language: ooc
" Maintainer: Curtis McEnroe
" Latest Revision: 11 September 2011

if exists("b:current_syntax")
  finish
endif

syn keyword oocExternal import include use

syn keyword oocPrimitive Int Int8 Int16 Int32 Int64 Int80 Int128
syn keyword oocPrimitive UInt UInt8 UInt16 UInt32 UInt64 UInt80 UInt 128
syn keyword oocPrimitive Octet Short UShort Long ULong LLong ULLong
syn keyword oocPrimitive Float Double LDouble Float32 Float64 Float128
syn keyword oocPrimitive Char UChar SChar WChar String
syn keyword oocPrimitive Void Pointer Bool SizeT This

syn keyword oocDeclaration class cover extends from func implement interface operator extend

syn keyword oocStorageClass abstract static final extern const proto unmangled

syn keyword oocScopeDecl private protected public internal

syn keyword oocMemory new this as super

syn keyword oocStatement break return continue
syn keyword oocLabel case
syn keyword oocConditional if else match
syn keyword oocRepeat while for do
syn keyword oocExceptions try catch finally

syn keyword oocBoolean true false
syn keyword oocConstant null

syn match oocEscapedChar display contained "\\\([\\\"\'nrbtf]\|[0-9]\{1,3}\|u[0-9]\{1,4}\)"
syn region oocString start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=oocEscapedChar,@Spell

syn match oocCharacter "L\='[^\\]'"
syn match oocCharacter "L'[^']*'" contains=oocEscapedChar

syn keyword oocTodo TODO FIXME
syn region oocComment start="/\*" end="\*/" contains=oocTodo,@Spell
syn match oocLineComment "//.*" contains=oocTodo,@Spell

" Mostly stolen from syntax/c.vim
syn match oocNumbers display transparent "\<\d\|\.\d" contains=oocNumber,oocFloat,oocOctal
syn match oocNumber display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
syn match oocNumber display contained "0x\x\+\(u\=l\{0,2}\|ll\=u\)\>"
syn match oocOctal display contained "0\o\+\(u\=l\{0,2}\|ll\=u\)\>" contains=cOctalZero
syn match oocOctalZero display contained "\<0"
syn match oocFloat display contained "\d\+f"
syn match oocFloat display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
syn match oocFloat display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"
syn match oocFloat display contained "\d\+e[-+]\=\d\+[fl]\=\>"

syn match oocSuffix "\~\w\+"

"""

hi def link oocStatement Statement
hi def link oocLabel Label
hi def link oocConditional Conditional
hi def link oocRepeat Repeat
hi def link oocExceptions Exception
hi def link oocBoolean Boolean
hi def link oocConstant Constant
hi def link oocExternal Include
hi def link oocPrimitive Type
hi def link oocDeclaration Structure
hi def link oocStorageClass StorageClass
hi def link oocMemory Operator
hi def link oocEscapedChar SpecialChar
hi def link oocString String
hi def link oocCharacter Character
hi def link oocComment Comment
hi def link oocLineComment Comment
hi def link oocTodo Todo
hi def link oocNumber Number
hi def link oocOctal Number
hi def link oocOctalZero PreProc
hi def link oocFloat Float
hi def link oocSuffix Identifier

let b:current_syntax = "ooc"
