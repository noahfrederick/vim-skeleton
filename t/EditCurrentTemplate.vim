describe 'skeleton#EditCurrentTemplate'
  after
    unlet b:skeleton_template_file
  end

  it 'fails when no template was loaded'
    Expect skeleton#EditCurrentTemplate('edit') =~# '^echoerr'
  end

  it 'edits the template file that was loaded'
    let b:skeleton_template_file = 'skel.test'
    Expect skeleton#EditCurrentTemplate('edit') =~# b:skeleton_template_file
  end

  it 'uses the editing command passed to it'
    let b:skeleton_template_file = 'skel.test'
    Expect skeleton#EditCurrentTemplate('edit') =~# '^edit'
    Expect skeleton#EditCurrentTemplate('split') =~# '^split'
  end
end
