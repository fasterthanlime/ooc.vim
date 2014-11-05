
[![Build Status](https://travis-ci.org/fasterthanlime/ooc.vim.png?branch=master)](https://travis-ci.org/fasterthanlime/ooc.vim)

# ooc.vim

This is the official vim plug-in for ooc language support.

It provides:

  * Syntax highlighting
  * Indentation support
  * A syntastic plug-in for use with [sam][sam]
  * `:make` command support (launches `rock -v`)

## Install instructions

[Vundle][vundle] is a very neat tool to manage your vim plugins, and
is the recommended way to get ooc.vim and keep it up-to-date.

Add this to your `~/.vimrc`:

```viml
Bundle 'fasterthanlime/ooc.vim'
```

Then restart vim, run `:BundleInstall`, and you're set!

Installing ooc.vim with pathogen should be as easy as cloning it in
`~/.vim/bundle`

## Syntastic

To use the syntastic plug-in, first you have to install [syntastic][syntastic]
itself.

For now, the dependencies are as follow:

  * [rock][rock] 0.9.9 or greater, in your `$PATH`
  * [sam][sam] 0.10.1 or greater, in your `$PATH`

This plug-in uses the `sam check` command if the dependencies above are met, to
check whether there are errors in an .ooc file. It will only work for .ooc files
that are part of a project that has a `.use file`, not for standalone ooc files.

Checking with rock can be slow at times, especially within large projects. There
are two solutions to that.

One can change the checking mode using the `g:syntastic_sam_mode` option. To only
do syntax checking instead of a full source check, do:

```viml
let g:syntastic_sam_mode = 'syntax'
```

The valid values for `g:syntastic_sam_mode` are `syntax`, `check`, and `codegen`
(from fastest to most thorough).

[vundle]: https://github.com/gmarik/vundle
[syntastic]: https://github.com/scrooloose/syntastic
[rock]: https://github.com/fasterthanlime/rock
[sam]: https://github.com/fasterthanlime/sam

