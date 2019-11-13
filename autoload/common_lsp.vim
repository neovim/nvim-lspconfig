function! common_lsp#texlab(config)
  return luaeval("require'common_lsp'.texlab.setup(_A)", a:config)
endfunction

function! common_lsp#setup(name, config)
  return luaeval("local name, config = unpack(_A) require'common_lsp'[name].setup(config)", {a:name, a:config})
endfunction
