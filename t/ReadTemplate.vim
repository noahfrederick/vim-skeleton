let g:skeleton_test_dir = 't'
let g:skeleton_template_dir = g:skeleton_test_dir . '/templates'

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
