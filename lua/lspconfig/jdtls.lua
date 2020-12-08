local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local handlers = require 'vim.lsp.handlers'
local path = util.path

local server_name = "jdtls"

local function make_installer()
  local install_dir = path.join { util.base_install_dir, server_name }
  local tar_name = "jdt-language-server-latest.tar.gz"
  local script = string.format([[
    curl -LO http://download.eclipse.org/jdtls/snapshots/%s > %s
    tar xf %s
  ]], tar_name, tar_name, tar_name)
  local launcher_ls = "ls " .. path.join { install_dir, "plugins", "org.eclipse.equinox.launcher_*.jar" }

  local X = {}

  function X.install()
    if not util.has_bins("curl", "tar") then
      error('Need the binaries "curl", "tar" to install this.')
      return
    end

    vim.fn.mkdir(install_dir, "p")
    util.sh(script, install_dir)
  end

  function X.info()
    return {
      is_installed = util.path.exists(install_dir, 'features') ~= false;
      install_dir = install_dir;
    }
  end

  function X.get_os_config()
    if vim.fn.has("osx") == 1 then
      return "config_mac"
    elseif vim.fn.has("unix") == 1 then
      return "config_linux"
    else
      return "config_win"
    end
  end

  function X.get_launcher()
    local file = io.popen(launcher_ls)
    local results = {}

    for line in file:lines() do
      table.insert(results, line)
    end

    if #results == 1 then
      return results[1]
    end

    error("Could not find launcher for jdtls.")
  end

  function X.configure(config)
    local install_info = X.info()
    local launcher_path = X.get_launcher()

    if install_info.is_installed then
      config.cmd = vim.list_extend(
        vim.list_extend(
          {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.level=ALL",
            "-noverify",
            "-Xmx1G",
          },
          config.init_options.jvm_args),
        {
          "-jar", launcher_path,
          "-configuration", path.join { install_dir, config.init_options.os_config or X.get_os_config() },
          "-data", config.init_options.workspace,
          -- TODO: Handle Java versions 8 and under. This may just work...
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED"
        })
    end
  end

  return X
end

local installer = make_installer()

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
  on_new_config = function(config)
    installer.configure(config)
  end;
  docs = {
    description = [[
https://projects.eclipse.org/projects/eclipse.jdt.ls

Language server can be installed with `:LspInstall jdtls`

Language server for Java.
    ]];
    default_config = {
      root_dir = [[root_pattern(".git")]];
    };
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
