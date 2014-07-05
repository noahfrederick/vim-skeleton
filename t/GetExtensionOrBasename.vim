describe 'skeleton#GetExtensionOrBasename'
  it 'returns the file extension when there is one'
    Expect skeleton#GetExtensionOrBasename('example.vim') ==# 'vim'
    Expect skeleton#GetExtensionOrBasename('foo/example.2.vim') ==# 'vim'
  end

  it 'returns the base name when there is no extension'
    Expect skeleton#GetExtensionOrBasename('bar/example') ==# 'example'
  end

  it 'returns -1 on buffer names surrounded by brackets'
    Expect skeleton#GetExtensionOrBasename('[new]') == -1
  end
end
