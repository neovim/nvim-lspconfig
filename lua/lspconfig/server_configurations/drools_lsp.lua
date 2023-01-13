local util = require 'lspconfig.util'

local get = function(config, section, key)
  return vim.tbl_get(config.settings, section, key) and config.settings[section][key] or nil
end

local get_java_bin = function()
  local java_bin = vim.env.JAVA_HOME and util.path.join(vim.env.JAVA_HOME, 'bin', 'java') or 'java'
  if vim.fn.has 'win32' == 1 then
    java_bin = java_bin .. '.exe'
  end
  return java_bin
end

return {
  default_config = {
    filetypes = { 'drools' },
    root_dir = util.find_git_ancestor(),
    single_file_support = true,
    on_new_config = function(config)
      if not config.cmd then
        local java_bin = get(config, 'java', 'bin') or get_java_bin()
        local java_opts = get(config, 'java', 'opts') or {}
        local drools_jar = get(config, 'drools', 'jar') or 'drools-lsp-server-jar-with-dependencies.jar'

        config.cmd = { java_bin }
        for _, o in ipairs(java_opts) do
          table.insert(config.cmd, o)
        end
        --- @diagnostic disable-next-line:missing-parameter
        vim.list_extend(config.cmd, { '-jar', drools_jar })
      end
    end,
  },
  docs = {
    description = [[
https://github.com/kiegroup/drools-lsp

Language server for the [Drools Rule Language (DRL)](https://docs.drools.org/latest/drools-docs/docs-website/drools/language-reference/#con-drl_drl-rules).

The `drools-lsp` server is a self-contained java jar file (`drools-lsp-server-jar-with-dependencies.jar`), and can be downloaded from [https://github.com/kiegroup/drools-lsp/releases/](https://github.com/kiegroup/drools-lsp/releases/).

Configuration information:
```lua
-- Option 1) Specify the entire command:
require('lspconfig').drools_lsp.setup {
  cmd = {
    '/path/to/java',
    '-jar',
    '/path/to/drools-lsp-server-jar-with-dependencies.jar',
  },
}

-- Option 2) Specify just the jar location (the JAVA_HOME environment variable will be respected):
require('lspconfig').drools_lsp.setup {
  settings = {
    drools = {
      jar = '/path/to/drools-lsp-server-jar-with-dependencies.jar',
    },
  },
}

-- Option 3) Specify the jar location plus the java bin path and/or java opts:
require('lspconfig').drools_lsp.setup {
  settings = {
    java = {
      bin = '/path/to/java',
      opts = { '-Xmx500m' },
    },
    drools = {
      jar = '/path/to/drools-lsp-server-jar-with-dependencies.jar',
    },
  },
}
```

It is also recommended to set up automatic filetype detection for drools (`*.drl`) files, for example:
```vim
autocmd BufRead,BufNewFile *.drl set filetype=drools
```
]],
  },
}
