local configs = require "nvim_lsp/configs"
local util = require "nvim_lsp/util"

local server_name = "codeqlls"

local root_pattern = util.root_pattern("qlpack.yml")

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

configs[server_name] = {
    default_config = {
        cmd = {"codeql", "execute", "language-server", "--check-errors", "ON_CHANGE", "-q"};
        filetypes = {'codeql'};
        root_dir = function(fname)
            return root_pattern("qlpack.yml") or util.path.dirname(fname)
        end;
        log_level = vim.lsp.protocol.MessageType.Warning;
        before_init = function(initialize_params, config)
            initialize_params['workspaceFolders'] = {{
                    name = 'workspace',
                    uri = initialize_params['rootUri']
            }}
        end;
        settings = {
            ["search_path"] = {}
        };
    };
    docs = {
        package_json = "https://github.com/github/vscode-codeql/blob/master/extensions/ql-vscode/package.json";
        description = [[
Reference:
https://help.semmle.com/codeql/codeql-cli.html

Binaries:
https://github.com/github/codeql-cli-binaries
        ]];
        default_config = {
            settings = {
                search_path = [[list containing all search paths, eg: '~/codeql-home/codeql-repo']];
            };
        };
    };
    on_new_config = function(config)
        file = io.open("/tmp/neovim.log", "a")
        io.output(file)
        io.write(dump(config.settings))
        io.close(file)
        if type(config.settings.search_path) == 'table' and not vim.tbl_isempty(config.settings.search_path) then
            local search_path = "--search-path="
            for _, path in ipairs(config.settings.search_path) do
                search_path = search_path..vim.fn.expand(path)..":"
            end
            config.cmd = {"codeql", "execute", "language-server", "--check-errors", "ON_CHANGE", "-q", search_path}
        end
    end;
}
