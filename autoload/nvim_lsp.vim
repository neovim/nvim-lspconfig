function! nvim_lsp#setup(name, config)
  return luaeval("require'nvim_lsp'[_A[1]].setup(_A[2])", [a:name, a:config])
endfunction
