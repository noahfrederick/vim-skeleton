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

""
" @section About, about
" @plugin(stylized) is distributed under the same terms as Vim itself (see
" |license|)
"
" You can find the latest version of this plug-in on GitHub:
" https://github.com/noahfrederick/vim-skeleton
"
" Please report issues on GitHub as well:
" https://github.com/noahfrederick/vim-skeleton/issues

if !exists('g:skeleton_template_dir')
  ""
  " The directory that contains skeleton template files. Example:
  " >
  "   let g:skeleton_template_dir = "~/.vim/templates"
  " <
  " Default: "~/.vim/templates"
  let g:skeleton_template_dir = '~/.vim/templates'
endif

if !exists("g:skeleton_replacements")
  ""
  " Dictionary of custom global replacement functions. Each function should be
  " named after the corresponding template placeholder, and should return the
  " value with which the placeholder will be substituted. For example:
  " >
  "   function! g:skeleton_replacements.TITLE()
  "     return "The Title"
  "   endfunction
  " <
  " Registering the above function would replace the @TITLE@ placeholder with
  " the return value, "The Title".
  "
  " Default: {}
  "
  " To create one or more replacements for a particular file-type, add your
  " function instead to a g:skeleton_replacements_{filetype} dictionary. For
  " example, to create a TITLE placeholder for Ruby files:
  " >
  "   let g:skeleton_replacements_ruby = {}
  "
  "   function! g:skeleton_replacements_ruby.TITLE()
  "     return "The Title"
  "   endfunction
  " <
  " This will override g:skeleton_replacements.TITLE() (if defined) for Ruby
  " files.
  let g:skeleton_replacements = {}
endif

augroup Skeleton
  autocmd!
  autocmd BufNewFile * call skeleton#LoadByFilename(expand('<amatch>'))
  autocmd FileType   * call skeleton#LoadByFiletype(expand('<amatch>'), expand('<afile>'))
augroup END

""
" Edits a template file. If the optional [template] argument is omitted, edits
" the template inserted into the current buffer.
command! -bang -bar -nargs=? -complete=customlist,skeleton#CompleteTemplateNames
  \ SkelEdit execute skeleton#EditTemplate(<q-args>, 'edit<bang>')
