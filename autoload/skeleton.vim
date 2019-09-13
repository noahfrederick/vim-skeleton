" Skeleton:    Initialize new Vim buffers with file-type-specific templates
" Maintainer:  Noah Frederick (http://noahfrederick.com)

let s:filetype_extensions = {
      \ 'python':      'py',
      \ 'ruby':        'rb',
      \ 'yaml':        'yml',
      \ 'javascript':  'js',
      \ }

function! s:template_path(filename)
  return expand(join([g:skeleton_template_dir, a:filename], '/'))
endfunction

function! skeleton#GetExtensionOrBasename(filename)
  let ext = fnamemodify(a:filename, ':e')

  if ext == ''
    let ext = fnamemodify(a:filename, ':t')
  endif
  if ext =~ '['
    return -1
  endif

  return ext
endfunction

function! skeleton#FiletypeToExtension(type)
  return get(s:filetype_extensions, a:type, a:type)
endfunction

function! skeleton#InsertTemplate(tmpl, force)
  let filename = expand('%')

  if skeleton#ClearBufferMaybe(filename, a:force) == -1
    echoerr 'Buffer not empty or file exists on disk. Use ! to override.'
    return -1
  endif

  let ext = skeleton#GetExtensionOrBasename(filename)

  return skeleton#Load(ext, filename, a:tmpl)
endfunction

function! skeleton#Load(ext, filename, tmpl)
  if &filetype ==# ''
    let type = a:ext
  else
    let type = &filetype
  endif

  if a:tmpl ==# ''
    " Use custom template name if custom function is defined
    if ! skeleton#ReadCustomTemplate(a:filename, type)
      " Look for template named after containing directory with extension
      if ! skeleton#ReadTemplate(substitute(fnamemodify(a:filename, ':h:t'), '\W', '_', 'g').'.'.a:ext)
        " Look for generic template with extension
        if ! skeleton#ReadTemplate('skel.'.a:ext)
          return 0
        endif
      endif
    endif
  elseif ! skeleton#ReadTemplate(a:tmpl)
    return 0
  endif

  " Do any custom replacements defined for file ext
  if exists('g:skeleton_replacements_'.type)
    call skeleton#DoReplacementsInDict(g:skeleton_replacements_{type})
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

function! skeleton#ReadCustomTemplate(filename, type) abort
  " Work around bug in older Vims by catching the error
  "   7.4.086  can't skip over expression when not evaluating for dict member
  try
    if type(get(g:skeleton_find_template, a:type)) == 2 &&
          \ skeleton#ReadTemplate(g:skeleton_find_template[a:type](a:filename))
      return 1
    endif
  catch /^Vim\%((\a\+)\)\=:E116/
  endtry

  return 0
endfunction

function! skeleton#DoReplacementsInDict(dict)
  for [key, ReplaceFunc] in items(a:dict)
    call skeleton#Replace(key, call(ReplaceFunc, [], {}))
  endfor
endfunction

function! skeleton#DoDefaultReplacements(filename)
  let filename = fnamemodify(a:filename, ':t')
  let basename = fnamemodify(a:filename, ':t:r')
  let baseNameTitleCase = substitute(basename, '\(\<\w\+\>\)', '\u\1', 'g')
  let BASENAME = toupper(basename)

  call skeleton#Replace('FILENAME', filename)
  call skeleton#Replace('BASENAME', basename)
  call skeleton#Replace('DATE', strftime('%a, %d %b %Y'))
  call skeleton#Replace('YEAR', strftime('%Y'))
  call skeleton#Replace('Basename', baseNameTitleCase)
  call skeleton#Replace('BASENAMECAPS', BASENAME)

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
