function! common_lsp#texlab(config)
  return luaeval("require'common_lsp/texlab'.texlab(_A)", a:config)
endfunction
