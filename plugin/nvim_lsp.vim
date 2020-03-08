if exists('g:nvim_lsp')
  finish
endif
let g:nvim_lsp = 1

lua << EOF
lsp_complete_installable_servers = function()
  return table.concat(require'nvim_lsp'.available_servers(), '\n')
end
lsp_complete_servers = function()
  return table.concat(require'nvim_lsp'.installable_servers(), '\n')
end
require'nvim_lsp'._root._setup()
EOF
