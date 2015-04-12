let g:skeleton_test_dir = 't'
let g:skeleton_template_dir = g:skeleton_test_dir . '/templates'

filetype on
runtime! plugin/skeleton.vim

describe 'Editing a new buffer'
  after
    bdelete!
  end

  it 'does nothing if no template exists'
    edit test.markdown
    Expect &filetype ==# 'markdown'
    Expect filereadable(g:skeleton_template_dir.'/skel.markdown') == 0
    Expect getline(1) ==# ''
  end

  it 'reads a template based on file extension rather than filetype'
    edit test.hpp
    Expect &filetype ==# 'cpp'
    Expect filereadable(g:skeleton_template_dir.'/skel.cpp') == 1
    Expect filereadable(g:skeleton_template_dir.'/skel.hpp') == 1
    Expect getline(1) ==# 'Default template: skel.hpp'
  end
end
