let g:skeleton_test_dir = 't'
let g:skeleton_fixture_dir = g:skeleton_test_dir . '/fixtures'
let g:file_exists = g:skeleton_fixture_dir . '/exists.txt'
let g:file_exists_not = g:skeleton_fixture_dir . '/exists_not.txt'

runtime plugin/skeleton.vim

describe 'skeleton#ClearBufferMaybe'
  before
    new
  end

  after
    bdelete!
  end

  context 'without "force" parameter'
    it 'returns -1 if the buffer is not empty'
      0put = 'Existing text'
      Expect filereadable(g:file_exists_not) == 0
      Expect skeleton#ClearBufferMaybe(g:file_exists_not, 0) == -1
    end

    it 'returns -1 if the file exists on disk'
      Expect filereadable(g:file_exists) == 1
      Expect skeleton#ClearBufferMaybe(g:file_exists, 0) == -1
    end

    it 'returns 1 if the file does not exist and the buffer is empty'
      Expect filereadable(g:file_exists_not) == 0
      Expect skeleton#ClearBufferMaybe(g:file_exists_not, 0) == 1
    end
  end

  context 'with "force" parameter'
    it 'returns 1 if the buffer is not empty and clears it'
      0put = 'Existing text'
      Expect filereadable(g:file_exists_not) == 0
      Expect skeleton#ClearBufferMaybe(g:file_exists_not, 1) == 1
      Expect getline(1) ==# ''
      Expect line('$') == 1
    end

    it 'returns 1 if the file exists on disk'
      Expect filereadable(g:file_exists) == 1
      Expect skeleton#ClearBufferMaybe(g:file_exists, 1) == 1
    end

    it 'returns 1 if the file does not exist and the buffer is empty'
      Expect filereadable(g:file_exists_not) == 0
      Expect skeleton#ClearBufferMaybe(g:file_exists_not, 1) == 1
    end
  end
end
