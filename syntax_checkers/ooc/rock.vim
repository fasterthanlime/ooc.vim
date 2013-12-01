"============================================================================
"File:        rock.vim
"Description: Syntax checking plugin for syntastic.vim
"Maintainer:  Amos Wenger <amos.wenger at gmail dot com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================

if exists("g:loaded_syntastic_ooc_rock_checker")
    finish
endif
let g:loaded_syntastic_ooc_rock_checker=1

if !exists("g:syntastic_sam_exec")
    let g:syntastic_sam_exec = "sam"
endif

function! SyntaxCheckers_ooc_rock_IsAvailable() dict
    return executable(expand(g:syntastic_sam_exec))
endfunction

function! SyntaxCheckers_ooc_rock_GetHighlightRegex(i)
    return ''
endfunction

function! SyntaxCheckers_ooc_rock_GetLocList() dict
    let exe = expand(g:syntastic_sam_exec)
    let args = 'check'

    if exists("g:syntastic_sam_mode")
        let args .= ' --mode='
        let args .= g:syntastic_sam_mode
    endif

    let makeprg = self.makeprgBuild({
        \ 'exe': exe,
        \ 'args': args })

    let errorformat  = '%f:%l:%c error %m,'
    let errorformat .= '%f:%l:%c warning %m'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'ooc',
    \ 'name': 'rock',
    \ 'exec': 'rock'})
