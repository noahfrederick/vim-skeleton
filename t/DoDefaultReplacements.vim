describe 'skeleton#DoDefaultReplacements'
  before
    new
    0put = 'Start: @CURSOR@.'
    1put = ''
  end

  after
    bdelete!
  end

  it 'deletes an empty last line'
    Expect getline('$') ==# ''
    Expect line('$') == 3
    call skeleton#DoDefaultReplacements('test.txt')
    Expect line('$') == 2
  end

  it 'replaces the @CURSOR@ placeholder'
    call skeleton#DoDefaultReplacements('test.txt')
    Expect getline(1) ==# 'Start: .'
  end
end
