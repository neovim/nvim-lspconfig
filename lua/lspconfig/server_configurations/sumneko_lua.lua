vim.deprecate('sumneko_lua', 'lua_language_server', '0.2.0', 'lspconfig')
return require 'lspconfig.server_configurations.lua_language_server'
