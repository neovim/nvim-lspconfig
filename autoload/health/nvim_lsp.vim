function! health#nvim_lsp#check()
  call health#report_start('Checking language server protocol configuration')
  lua require 'nvim_lsp/health'.check_health()
endfunction
