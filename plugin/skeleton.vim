" Skeleton:    Initialize new Vim buffers with file-type-specific templates
" Maintainer:  Noah Frederick (http://noahfrederick.com)

if (exists('g:loaded_skeleton') && g:loaded_skeleton) || &cp
  finish
endif
let g:loaded_skeleton = 1

""
" @section Introduction, intro
" @stylized Skeleton
" @plugin(stylized) initializes new Vim buffers with file-type-specific
" templates.
"
" Add something like the following to ~/.vim/templates/skel.xml:
" >
"   <?xml version="1.0" encoding="UTF-8" ?>
"   <@BASENAME@>
"       @CURSOR@
"   </@BASENAME@>
" <
" And when you create a new buffer, e.g., books.xml, it will be initialized
" with your template:
" >
"   <?xml version="1.0" encoding="UTF-8" ?>
"   <books>
"       [cursor is here]
"   </books>
" <
" It differs from a snippet plug-in in that it is concerned with initializing
" new buffers with boilerplate text without any manual intervention such as
" triggering a snippet.
"
" @plugin(stylized) stays out of your way: it will never load a template
" unless the buffer is empty and is not associated with an existing file on
" disk. And if you don't happen to want to use the template for a particular
" file, issuing |undo| (u) will restore your empty buffer.
"
" This plug-in is only available if 'compatible' is not set.

augroup Skeleton
  autocmd!
  autocmd BufNewFile * call skeleton#LoadByFilename(expand('<amatch>'))
  autocmd FileType   * call skeleton#LoadByFiletype(expand('<amatch>'), expand('<afile>'))
augroup END

""
" Edits the active template file.
command! -bang -bar SkelEdit execute skeleton#EditCurrentTemplate('edit<bang>')
