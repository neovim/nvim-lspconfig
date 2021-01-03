local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local handlers = require 'vim.lsp.handlers'
local path = util.path

local server_name = "jdtls"

configs[server_name] = {
  default_config = {
    filetypes = { "java" };
    root_dir = util.root_pattern('.git');
    init_options = {
      workspace = path.join { vim.loop.os_homedir(), "workspace" };
      jvm_args = {};
      os_config = nil;
    };
    handlers = {
      -- Due to an invalid protocol implementation in the jdtls we have to
      -- conform these to be spec compliant.
      -- https://github.com/eclipse/eclipse.jdt.ls/issues/376
      -- Command in org.eclipse.lsp5j -> https://github.com/eclipse/lsp4j/blob/master/org.eclipse.lsp4j/src/main/xtend-gen/org/eclipse/lsp4j/Command.java
      -- CodeAction in org.eclipse.lsp4j -> https://github.com/eclipse/lsp4j/blob/master/org.eclipse.lsp4j/src/main/xtend-gen/org/eclipse/lsp4j/CodeAction.java
      -- Command in LSP -> https://microsoft.github.io/language-server-protocol/specification#command
      -- CodeAction in LSP -> https://microsoft.github.io/language-server-protocol/specification#textDocument_codeAction
      ['textDocument/codeAction'] = function(a, b, actions)
        for _,action in ipairs(actions) do
          -- TODO: (steelsojka) Handle more than one edit?
          -- if command is string, then 'ation' is Command in java format,
          -- then we add 'edit' property to change to CodeAction in LSP and 'edit' will be executed first
          if action.command == 'java.apply.workspaceEdit' then
            action.edit = action.edit or action.arguments[1]
          -- if command is table, then 'action' is CodeAction in java format
          -- then we add 'edit' property to change to CodeAction in LSP and 'edit' will be executed first
          elseif type(action.command) == 'table' and action.command.command == 'java.apply.workspaceEdit' then
            action.edit = action.edit or action.command.arguments[1]
          end
        end

        handlers['textDocument/codeAction'](a, b, actions)
      end
    };
  };
  docs = {
    description = [[
https://projects.eclipse.org/projects/eclipse.jdt.ls

Language server for Java.

See project page for installation instructions.
    ]];
    default_config = {
      root_dir = [[root_pattern(".git")]];
    };
  };
}
