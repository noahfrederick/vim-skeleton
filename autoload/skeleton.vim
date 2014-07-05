" Skeleton:    Initialize new Vim buffers with file-type-specific templates
" Maintainer:  Noah Frederick (http://noahfrederick.com)

function! s:template_path(filename)
  return expand(join([g:skeleton_template_dir, a:filename], '/'))
endfunction

function! skeleton#InsertTemplate(tmpl, force)
  let filename = expand('%')
  let ext = fnamemodify(filename, ':e')

  if g:skeleton_buffer_empty_or_abort(filename, a:force) == -1
    echoerr 'Buffer not empty or file exists on disk. Use ! to override.'
  endif

  if ext == ''
    let ext = fnamemodify(filename, ':t')
  endif

  return skeleton#Load(ext, filename, a:tmpl)
endfunction

function! skeleton#Load(type, filename, tmpl)
  if a:tmpl ==# ''
    " Use custom template name if custom function is defined
    if ! exists('*SkeletonFiletypeTemplate_'.a:type) || ! skeleton#ReadTemplate(SkeletonFiletypeTemplate_{a:type}(a:filename))
      " Look for template named after containing directory with extension
      if ! skeleton#ReadTemplate(substitute(fnamemodify(a:filename, ':h:t'), '\W', '_', 'g').'.'.a:type)
        " Look for generic template with extension
        if ! skeleton#ReadTemplate('skel.'.a:type)
          return 0
        endif
      endif
    endif
  elseif ! skeleton#ReadTemplate(a:tmpl)
    return 0
  endif

  " Do any custom replacements defined for file type
  if exists('g:skeleton_replacements_'.a:type)
    call skeleton#DoReplacementsInDict(g:skeleton_replacements_{a:type})
  endif

  " Do any custom replacements defined for all templates
  if exists('g:skeleton_replacements')
    call skeleton#DoReplacementsInDict(g:skeleton_replacements)
  endif

  " Do the default replacements including positioning the cursor
  call skeleton#DoDefaultReplacements(a:filename)

  return 1
endfunction

function! skeleton#ReadTemplate(filename) abort
  let b:skeleton_template_file = a:filename
  if !filereadable(s:template_path(b:skeleton_template_file))
    return 0
  endif
  let cpopts = &cpoptions
  set cpoptions-=a
  silent execute '0read '.s:template_path(b:skeleton_template_file)
  let &cpoptions = cpopts
  return 1
endfunction

function! skeleton#DoReplacementsInDict(dict)
  for [key, ReplaceFunc] in items(a:dict)
    call skeleton#Replace(key, call(ReplaceFunc, [], {}))
  endfor
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
  if getline('$') ==# ''
    $ delete _
  endif
  if line('$') > &lines
    1
  endif

  call skeleton#Replace('CURSOR', '')
endfunction

function! skeleton#Replace(placeholder, replacement)
  silent! execute '%substitute/@'.a:placeholder.'@/'.a:replacement.'/g'
endfunction

function! skeleton#EditTemplate(tmpl, cmd)
  if a:tmpl ==# ''
    if exists('b:skeleton_template_file')
      let path = s:template_path(b:skeleton_template_file)
    else
      return "echoerr 'No template is associated with this buffer'"
    endif
  else
    let path = s:template_path(a:tmpl)
  endif

  return join([a:cmd, path])
endfunction

function! skeleton#CompleteTemplateNames(A, L, P)
  let matches = split(globpath(g:skeleton_template_dir, a:A . '*'), "\n")
  return map(matches, 'fnamemodify(v:val, ":t")')
endfunction
