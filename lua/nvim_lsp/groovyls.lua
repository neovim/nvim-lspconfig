local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'
local groovy_server_path = "~/groovyls/build/libs/groovyls-all.jar"

configs.groovyls = {
  default_config = {

    cmd = {
      "java", "-jar", groovy_server_path,
    };
    filetypes = {"groovy", "gsp"};
    root_dir = util.root_pattern("grails-app", ".git");
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://github.com/prominic/groovy-language-server

Groovy Language Server
]];
    default_config = {
      root_dir = [[root_pattern("grails-app", ".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
