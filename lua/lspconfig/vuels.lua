local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "vuels"
local bin_name = "vls"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "vls" };
  binaries = {bin_name};
}

configs[server_name] = {
  default_config = {
    cmd = {bin_name};
    filetypes = {"vue"};
    root_dir = util.root_pattern("package.json", "vue.config.js");
    init_options = {
      config = {
        vetur = {
          useWorkspaceDependencies = false;
          validation = {
            template = true;
            style = true;
            script = true;
          };
          completion = {
            autoImport = false;
            useScaffoldSnippets = false;
            tagCasing = "kebab";
          };
          format = {
            defaultFormatter = {
              js = "none";
              ts = "none";
            };
            defaultFormatterOptions = {};
            scriptInitialIndent = false;
            styleInitialIndent = false;
          }
        };
        css = {};
        html = {
            suggest = {};
        };
        javascript = {
            format = {};
        };
        typescript = {
            format = {};
        };
        emmet = {};
        stylusSupremacy = {};
      };
    };
  };
  on_new_config = function(new_config)
    local install_info = installer.info()
    if install_info.is_installed then
      if type(new_config.cmd) == 'table' then
        -- Try to preserve any additional args from upstream changes.
        new_config.cmd[1] = install_info.binaries[bin_name]
      else
        new_config.cmd = {install_info.binaries[bin_name]}
      end
    end
  end;
  docs = {
    package_json = "https://raw.githubusercontent.com/vuejs/vetur/master/package.json";
    description = [[
https://github.com/vuejs/vetur/tree/master/server

Vue language server(vls)
`vue-language-server` can be installed via `:LspInstall vuels` or by yourself with `npm`:
```sh
npm install -g vls
```
]];
    default_config = {
      root_dir = [[root_pattern("package.json", "vue.config.js")]];
      init_options = {
        config = {
          vetur = {
            useWorkspaceDependencies = false;
            validation = {
              template = true;
              style = true;
              script = true;
            };
            completion = {
              autoImport = false;
              useScaffoldSnippets = false;
              tagCasing = "kebab";
            };
            format = {
              defaultFormatter = {
                js = "none";
                ts = "none";
              };
              defaultFormatterOptions = {};
              scriptInitialIndent = false;
              styleInitialIndent = false;
            }
          };
          css = {};
          html = {
              suggest = {};
          };
          javascript = {
              format = {};
          };
          typescript = {
              format = {};
          };
          emmet = {};
          stylusSupremacy = {};
        };
      };
    };
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
