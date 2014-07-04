let g:skeleton_test_dir = 't'
let g:skeleton_template_dir = g:skeleton_test_dir . '/templates'

describe 'skeleton#EditTemplate'
  after
    unlet b:skeleton_template_file
  end

  it 'fails when no template was loaded and empty string is passed'
    Expect skeleton#EditTemplate('', 'edit') =~# '^echoerr'
  end

  it 'edits the template file that was loaded when empty string is passed'
    let b:skeleton_template_file = 'skel.test'
    Expect skeleton#EditTemplate('', 'edit') =~# b:skeleton_template_file
  end

  it 'edits the supplied template file'
    Expect skeleton#EditTemplate('test.txt', 'edit') =~# g:skeleton_template_dir . '/test.txt$'
  end

  it 'uses the editing command passed to it'
    let b:skeleton_template_file = 'skel.test'
    Expect skeleton#EditTemplate('', 'edit') =~# '^edit'
    Expect skeleton#EditTemplate('', 'split') =~# '^split'
  end
end
