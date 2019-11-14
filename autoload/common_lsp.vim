function! common_lsp#setup(name, config)
  return luaeval("local name, config = unpack(_A) require'common_lsp'[name].setup(config)", {a:name, a:config})
endfunction

function! common_lsp#texlab(config)
  call common_lsp#setup("texlab", a:config)
endfunction

function! common_lsp#gopls(config)
  call common_lsp#setup("gopls", a:config)
endfunction

