vim.notify('`sumneko_lua` has been renamed to `lua_language_server`', vim.log.levels.WARN)
return require 'lspconfig.server_configurations.lua_language_server'
