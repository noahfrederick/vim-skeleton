" Skeleton:    Read in template based on file type
" Maintainer:  Noah Frederick (http://noahfrederick.com)
" Notes:       Based on tpope's ztemplate.vim and godlygeek's snippets.vim
"              https://github.com/tpope/tpope/blob/master/.vim/plugin/ztemplate.vim
"              https://github.com/godlygeek/vim-files/blob/master/plugin/snippets.vim

if (exists('g:loaded_skeleton') && g:loaded_skeleton) || &cp
  finish
endif
let g:loaded_skeleton = 1

if !exists('g:skeleton_template_dir')
  let g:skeleton_template_dir = '~/.vim/templates'
endif

augroup Skeleton
  autocmd!
  autocmd BufNewFile * call skeleton#LoadByFilename(expand('<amatch>'))
  autocmd FileType   * call skeleton#LoadByFiletype(expand('<amatch>'), expand('<afile>'))
augroup END

command! -bang -bar SkelEdit execute skeleton#EditCurrentTemplate('edit<bang>')
