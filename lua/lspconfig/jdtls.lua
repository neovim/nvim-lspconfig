local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local handlers = require 'vim.lsp.handlers'
local path = util.path

local server_name = 'jdtls'

local cmd = {
  util.path.join(tostring(vim.fn.getenv 'JAVA_HOME'), '/bin/java'),
  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  '-Dosgi.bundles.defaultStartLevel=4',
  '-Declipse.product=org.eclipse.jdt.ls.core.product',
  '-Dlog.protocol=true',
  '-Dlog.level=ALL',
  '-Xms1g',
  '-Xmx2G',
  '-jar',
  tostring(vim.fn.getenv 'JAR'),
  '-configuration',
  tostring(vim.fn.getenv 'JDTLS_CONFIG'),
  '-data',
  tostring(vim.fn.getenv 'WORKSPACE'),
  '--add-modules=ALL-SYSTEM',
  '--add-opens java.base/java.util=ALL-UNNAMED',
  '--add-opens java.base/java.lang=ALL-UNNAMED',
}

--- The presence of one of these files indicates a root directory.
--
-- We search for configuration files of the most common Java build systems. We
-- could add more build systems, such as Make, but let's keep things simple for
-- now.
local root_files = {
  -- Single-module projects
  {
    'build.xml', -- Ant
    'pom.xml', -- Maven
    'settings.gradle', -- Gradle
    'settings.gradle.kts', -- Gradle
  },
  -- Multi-module projects
  { 'build.gradle', 'build.gradle.kts' },
}

--- Callback function for the `language/status` notification.
--
-- The server sends a non-standard notification when the status of the language
-- server changes. This can be used to display progress as the server is
-- starting up.
local function on_language_status(_, _, result)
  local command = vim.api.nvim_command
  command 'echohl ModeMsg'
  command(string.format('echo "%s"', result.message))
  command 'echohl None'
end

-- If the text document version is 0, set it to nil instead so that Neovim
-- won't refuse to update a buffer that it believes is newer than edits.
-- See: https://github.com/eclipse/eclipse.jdt.ls/issues/1695
local function fix_zero_version(workspace_edit)
  if workspace_edit and workspace_edit.documentChanges then
    for _, change in pairs(workspace_edit.documentChanges) do
      local text_document = change.textDocument
      if text_document and text_document.version and text_document.version == 0 then
        text_document.version = nil
      end
    end
  end
  return workspace_edit
end

configs[server_name] = {
  default_config = {
    cmd = cmd,
    cmd_env = {
      JAR = vim.fn.getenv 'JAR',
      GRADLE_HOME = vim.fn.getenv 'GRADLE_HOME',
    },
    filetypes = { 'java' },
    root_dir = function(fname)
      for _, patterns in ipairs(root_files) do
        local root = util.root_pattern(unpack(patterns))(fname)
        if root then
          return root
        end
      end
      return vim.fn.getcwd()
    end,
    init_options = {
      workspace = path.join { vim.loop.os_homedir(), 'workspace' },
      jvm_args = {},
      os_config = nil,
    },
    handlers = {
      -- Due to an invalid protocol implementation in the jdtls we have to
      -- conform these to be spec compliant.
      -- https://github.com/eclipse/eclipse.jdt.ls/issues/376
      -- Command in org.eclipse.lsp5j -> https://github.com/eclipse/lsp4j/blob/master/org.eclipse.lsp4j/src/main/xtend-gen/org/eclipse/lsp4j/Command.java
      -- CodeAction in org.eclipse.lsp4j -> https://github.com/eclipse/lsp4j/blob/master/org.eclipse.lsp4j/src/main/xtend-gen/org/eclipse/lsp4j/CodeAction.java
      -- Command in LSP -> https://microsoft.github.io/language-server-protocol/specification#command
      -- CodeAction in LSP -> https://microsoft.github.io/language-server-protocol/specification#textDocument_codeAction
      ['textDocument/codeAction'] = function(a, b, actions)
        for _, action in ipairs(actions) do
          -- TODO: (steelsojka) Handle more than one edit?
          -- if command is string, then 'ation' is Command in java format,
          -- then we add 'edit' property to change to CodeAction in LSP and 'edit' will be executed first
          if action.command == 'java.apply.workspaceEdit' then
            action.edit = fix_zero_version(action.edit or action.arguments[1])
            -- if command is table, then 'action' is CodeAction in java format
            -- then we add 'edit' property to change to CodeAction in LSP and 'edit' will be executed first
          elseif type(action.command) == 'table' and action.command.command == 'java.apply.workspaceEdit' then
            action.edit = fix_zero_version(action.edit or action.command.arguments[1])
          end
        end
        handlers['textDocument/codeAction'](a, b, actions)
      end,

      ['textDocument/rename'] = function(a, b, workspace_edit)
        handlers['textDocument/rename'](a, b, fix_zero_version(workspace_edit))
      end,

      ['workspace/applyEdit'] = function(a, b, workspace_edit)
        handlers['workspace/applyEdit'](a, b, fix_zero_version(workspace_edit))
      end,

      ['language/status'] = vim.schedule_wrap(on_language_status),
    },
  },
  docs = {
    language_name = 'Java',
    package_json = 'https://raw.githubusercontent.com/redhat-developer/vscode-java/master/package.json',
    description = [[

https://projects.eclipse.org/projects/eclipse.jdt.ls

Language server for Java.

See project page for installation instructions.

Due to the nature of java, the settings for eclipse jdtls cannot be automatically
inferred. Please set the following environmental variables to match your installation. You can set these locally for your project with the help of [direnv](https://github.com/direnv/direnv). Note version numbers will change depending on your project's version of java, your version of eclipse, and in the case of JDTLS_CONFIG, your OS.

```bash
export JAR=/path/to/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.0.v20200915-1508.jar
export GRADLE_HOME=$HOME/gradle
export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
export JDTLS_CONFIG=/path/to/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_linux
export WORKSPACE=$HOME/workspace
```
    ]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
