function! nvim_lsp#setup(name, config)
  return luaeval("require'nvim_lsp'[_A[1]].setup(_A[2])", [a:name, a:config])
endfunction

" function! nvim_lsp#texlab(config)
"   call nvim_lsp#setup("texlab", a:config)
" endfunction

" function! nvim_lsp#gopls(config)
"   call nvim_lsp#setup("gopls", a:config)
" endfunction

