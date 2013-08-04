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
