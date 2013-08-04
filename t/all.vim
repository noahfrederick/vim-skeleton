let g:skeleton_test_dir = 't'
let g:skeleton_template_dir = g:skeleton_test_dir . '/templates'

describe 'skeleton#EditCurrentTemplate'
  after
    unlet b:skeleton_template_file
  end

  it 'fails when no template was loaded'
    Expect skeleton#EditCurrentTemplate("edit") =~# "\^echoerr"
  end

  it 'edits the template file that was loaded'
    let b:skeleton_template_file = "skel.test"
    Expect skeleton#EditCurrentTemplate("edit") =~# b:skeleton_template_file
  end

  it 'uses the editing command passed to it'
    let b:skeleton_template_file = "skel.test"
    Expect skeleton#EditCurrentTemplate("edit") =~# "\^edit"
  end
end

describe 'skeleton#Replace'
  before
    new
    0put = '1: Replace @ME@.'
    1put = '2: Foo @BAR@ @BAR@.'
    2put = '3: Start: @CURSOR@.'
  end

  after
    bdelete!
  end

  it 'replaces a placeholder with the given string'
    call skeleton#Replace('ME', 'my name')
    Expect getline(1) ==# '1: Replace my name.'
  end

  it 'replaces every placeholder with the given string'
    call skeleton#Replace('BAR', 'baz')
    Expect getline(2) ==# '2: Foo baz baz.'
  end

  it 'leaves the cursor at the position of the replaced text'
    call skeleton#Replace('CURSOR', '')
    let end_pos = getpos('.')
    Expect getline(3) ==# '3: Start: .'
    Expect end_pos[1] == 3
  end
end

describe 'skeleton#ReadTemplate'
  before
    new
  end

  after
    bdelete!
  end

  it 'does nothing if the template does not exist'
    let result = skeleton#ReadTemplate('xxx')
    Expect result == 0
    Expect getline(1) ==# ''
  end

  it 'reads the template into the buffer if it exists'
    let result = skeleton#ReadTemplate('skel.txt')
    Expect result == 1
    Expect getline(1) ==# 'Default template: skel.txt'
  end

  it 'sets b:skeleton_template_file'
    call skeleton#ReadTemplate('skel.txt')
    Expect b:skeleton_template_file ==# g:skeleton_template_dir . '/skel.txt'
  end
end

let g:skeleton_called_custom_template_func = 0

function! SkeletonCustomTemplate_custom(filename)
  let g:skeleton_called_custom_template_func = 1
  return 'custom.txt'
endfunction

describe 'skeleton#Load'
  before
    new
  end

  after
    bdelete!
  end

  it 'does nothing if the buffer is not empty'
    0put = 'Existing text'
    call skeleton#Load('txt', 'test.txt')
    Expect line('$') == 2
    Expect getline(1) ==# 'Existing text'
    Expect getline('$') ==# ''
  end

  it 'does nothing if the file exists on disk'
    let test_file = g:skeleton_test_dir . '/exists.txt'
    Expect filereadable(test_file) == 1
    call skeleton#Load('txt', test_file)
    Expect getline(1) ==# ''
  end

  it 'returns -1 when it aborts'
    0put = 'Existing text'
    let result = skeleton#Load('txt', 'test.txt')
    Expect result == -1
  end

  it 'does nothing if no template exists'
    Expect filereadable(g:skeleton_template_dir.'/skel.xxx') == 0
    call skeleton#Load('xxx', 'test.xxx')
    Expect getline(1) ==# ''
  end

  it 'returns 0 when no template exists'
    Expect filereadable(g:skeleton_template_dir.'/skel.xxx') == 0
    let result = skeleton#Load('xxx', 'test.xxx')
    Expect result == 0
  end

  it 'calls a custom template function if it exists'
    call skeleton#Load('custom', 'test.custom')
    Expect g:skeleton_called_custom_template_func == 1
  end

  it 'reads a custom template if possible'
    Expect filereadable(g:skeleton_template_dir.'/custom.txt') == 1
    call skeleton#Load('custom', 'test.txt')
    Expect getline(1) ==# 'Custom template: custom.txt'
  end

  it 'reads a template based on the parent dir if possible'
    Expect filereadable(g:skeleton_template_dir.'/dir.txt') == 1
    call skeleton#Load('txt', 'dir/test.txt')
    Expect getline(1) ==# 'Directory template: dir.txt'
  end

  it 'reads a default skel.ext template'
    Expect filereadable(g:skeleton_template_dir.'/skel.txt') == 1
    call skeleton#Load('txt', 'test.txt')
    Expect getline(1) ==# 'Default template: skel.txt'
  end

  it 'returns 1 when it loads a template'
    Expect filereadable(g:skeleton_template_dir.'/skel.txt') == 1
    let result = skeleton#Load('txt', 'test.txt')
    Expect result == 1
  end
end
