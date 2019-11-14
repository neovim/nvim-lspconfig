function! common_lsp#setup(name, config)
  return luaeval("require'common_lsp'[_A[1]].setup(_A[2])", [a:name, a:config])
endfunction

function! common_lsp#texlab(config)
  call common_lsp#setup("texlab", a:config)
endfunction

function! common_lsp#gopls(config)
  call common_lsp#setup("gopls", a:config)
endfunction

