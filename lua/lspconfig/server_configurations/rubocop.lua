local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'rubocop', '--lsp' },
    filetypes = { 'ruby' },
    root_dir = util.root_pattern('Gemfile', '.git'),
  },
  on_new_config = function(config, root_dir)
    -- prepend 'bundle exec' to cmd if bundler is being used
    local gemfile_path = util.path.join(root_dir, 'Gemfile')
    if util.path.exists(gemfile_path) then
      config.cmd = { 'bundle', 'exec', unpack(config.cmd) }
    end
  end,
  docs = {
    description = [[
https://github.com/rubocop/rubocop
    ]],
    default_config = {
      root_dir = [[root_pattern("Gemfile", ".git")]],
    },
  },
}
