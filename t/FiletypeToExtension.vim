describe 'skeleton#FiletypeToExtension'
  it 'returns the file extension when defined'
    let provider = {
          \ "ruby": "rb",
          \ "javascript": "js",
          \ "php": "php",
          \ "custom": "custom",
          \ }
    for [type, ext] in items(provider)
      Expect skeleton#FiletypeToExtension(type) ==# ext
    endfor
  end
end
