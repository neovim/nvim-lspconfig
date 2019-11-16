function! s:complete_server_names(A,L,P) abort
  return luaeval("table.concat(require'nvim_lsp'.available_servers(), '\\n')")
endfunction

function! s:complete_installable_server_names(A,L,P) abort
  return luaeval("table.concat(require'nvim_lsp'.installable_servers(), '\\n')")
endfunction

lua << EOF
require'nvim_lsp'._root._setup()
EOF
