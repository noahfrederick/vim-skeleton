" Skeleton:    Read in template based on file type
" Maintainer:  Noah Frederick (http://noahfrederick.com)
" Notes:       Based on tpope's ztemplate.vim and godlygeek's snippets.vim
"              https://github.com/tpope/tpope/blob/master/.vim/plugin/ztemplate.vim
"              https://github.com/godlygeek/vim-files/blob/master/plugin/snippets.vim

function! skeleton#LoadByFilename(filename)
  let ext = fnamemodify(a:filename, ':e')
  if ext == ''
    let ext = (fnamemodify(a:filename, ':t'))
  endif
  if ext =~ '['
    return
  endif
  call skeleton#Load(ext, a:filename)
endfunction

function! skeleton#LoadByFiletype(type, filename)
  if a:type == 'python'
    let ext = 'py'
  elseif a:type == 'ruby'
    let ext = 'rb'
  else
    let ext = a:type
  endif
  call skeleton#Load(ext, a:filename)
endfunction

function! skeleton#Load(type, filename)
  " Abort if buffer is non-empty or file already exists
  if ! (line('$') == 1 && getline('$') == '') || filereadable(a:filename)
    return
  endif

  " Look for template named after containing directory with extension
  if ! skeleton#ReadTemplate(substitute(fnamemodify(a:filename, ':h:t'), '\W', '_', 'g').'.'.a:type)
    " Look for generic template with extension
    if ! skeleton#ReadTemplate('skel.'.a:type)
      return
    endif
  endif

  " Do any custom replacements defined for all templates
  if exists('*SkeletonCustomReplace')
    call SkeletonCustomReplace(a:filename)
  endif

  " Do any custom replacements defined for file type
  if exists('*SkeletonCustomReplace_'.a:type)
    call SkeletonCustomReplace_{a:type}(a:filename)
  endif

  " Do the default replacements including positioning the cursor
  call skeleton#DoDefaultReplacements(a:filename)
endfunction

function! skeleton#ReadTemplate(filename) abort
  let b:skeleton_template_file = g:skeleton_template_dir.'/'.a:filename
  if !filereadable(expand(b:skeleton_template_file))
    return 0
  endif
  let cpopts = &cpoptions
  set cpoptions-=a
  silent execute '0read '.b:skeleton_template_file
  let &cpoptions = cpopts
  return 1
endfunction

function! skeleton#DoDefaultReplacements(filename)
  let filename = fnamemodify(a:filename, ':t')
  let basename = fnamemodify(a:filename, ':t:r')

  call skeleton#Replace('FILENAME', filename)
  call skeleton#Replace('BASENAME', basename)
  call skeleton#Replace('DATE', strftime('%a, %d %b %Y'))
  call skeleton#Replace('YEAR', strftime('%Y'))

  " Disable folding lest we delete more than the extra line
  normal! zn

  " Delete extra line
  $ delete
  if line('$') > &lines
    1
  endif

  call skeleton#Replace('CURSOR', '')
endfunction

function! skeleton#Replace(placeholder, replacement)
  silent! execute '%substitute/@'.a:placeholder.'@/'.a:replacement.'/g'
endfunction

function! skeleton#EditCurrentTemplate(cmd)
  if !exists('b:skeleton_template_file')
    return "echoerr 'No template is associated with this buffer'"
  endif
  return a:cmd.' '.b:skeleton_template_file
endfunction
