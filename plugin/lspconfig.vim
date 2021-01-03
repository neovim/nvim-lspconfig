if exists('g:lspconfig')
  finish
endif
let g:lspconfig = 1

lua << EOF
lsp_complete_installable_servers = function()
  return table.concat(require'lspconfig'.available_servers(), '\n')
end
require'lspconfig'._root._setup()
EOF
