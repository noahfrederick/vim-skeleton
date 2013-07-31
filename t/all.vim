" All tests are thrown in here for now

let g:skeleton_test_dir = expand('<sfile>:p:h')
let g:skeleton_plugin_dir = fnamemodify(g:skeleton_test_dir, ':h')
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
