local configs = require 'lspconfig/configs'
local lspui = require 'lspconfig/_lspui'

local M = {
  util = require 'lspconfig/util';
}

M._root = {}

function M.available_servers()
  return vim.tbl_keys(configs)
end

function M.installable_servers()
  print("deprecated, see https://github.com/neovim/neovim/wiki/Following-HEAD")
end

-- Called from plugin/lspconfig.vim because it requires knowing that the last
-- script in scriptnames to be executed is lspconfig.
function M._root._setup()
  M._root.commands = {
    LspInfo = {
      function()
        -- These options need to be cached before switching to the floating
        -- buffer.
        local buf_clients = vim.lsp.buf_get_clients()
        local clients = vim.lsp.get_active_clients()
        local buffer_filetype = vim.bo.filetype
        local buffer_dir = vim.fn.expand('%:p:h')

        local win_info = lspui.percentage_range_window(0.8, 0.7)
        local bufnr, win_id = win_info.bufnr, win_info.win_id

        local buf_lines = {}
        local header = {
          "Available servers:",
          "\t"..table.concat(vim.tbl_keys(configs), ', '),
          "",
          "Clients attached to this buffer: "..tostring(#buf_clients)
        }
        vim.list_extend(buf_lines, header)

        for _, client in ipairs(buf_clients) do
          local client_info = {
            "",
            "Client: "..tostring(client.id),
            "\tname: "..client.name,
            "\troot: "..client.workspaceFolders[1].name,
            "\tfiletypes: "..table.concat(client.config.filetypes, ', '),
            "\tcmd: "..table.concat(client.config.cmd, ', '),
          }
           vim.list_extend(buf_lines, client_info)
        end

        local active_section_header = {
          "",
          "Total active clients: "..tostring(#clients),
        }
        vim.list_extend(buf_lines, active_section_header)
        for _, client in ipairs(clients) do
          local client_info = {
            "",
            "Client: "..tostring(client.id),
            "\tname: "..client.name,
            "\troot: "..client.workspaceFolders[1].name,
            "\tfiletypes: "..table.concat(client.config.filetypes, ', '),
            "\tcmd: "..table.concat(client.config.cmd, ', '),
          }
           vim.list_extend(buf_lines, client_info)
        end
        local matching_config_header = {
          "",
          "Clients that match the current buffer filetype:",
        }
        local cmd_not_found_msg = "False. Please check your path and ensure the server is installed"
        vim.list_extend(buf_lines, matching_config_header)
        for _, config in pairs(configs) do
          --TODO(mjlbach): This is why the command is slow.
          -- We should change config initialization so this is cached (generally)
          local config_table = config.make_config(buffer_dir)

          local cmd_is_executable, cmd
          if config_table.cmd then
            cmd = table.concat(config_table.cmd, " ")
            if vim.fn.executable(config_table.cmd[1]) == 1 then
              cmd_is_executable = "True"
            else
              cmd_is_executable = cmd_not_found_msg
            end
          else
            cmd = "cmd not defined"
            cmd_is_executable = cmd
          end

          for _, filetype_match in ipairs(config_table.filetypes) do
            if buffer_filetype == filetype_match then
              local matching_config_info = {
                "",
                "Config: "..config.name,
                "\tcmd: "..cmd,
                "\tcmd is executable: ".. cmd_is_executable,
                "\tidentified root: "..(config_table.root_dir or "None"),
                "\tcustom handlers: "..table.concat(vim.tbl_keys(config_table.handlers), ", "),
              }
             vim.list_extend(buf_lines, matching_config_info)
            end
          end
        end
        buf_lines = vim.lsp.util._trim_and_pad(buf_lines, { pad_left = 2, pad_top = 1})
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_lines )
        vim.fn.matchadd("Title", table.concat(vim.tbl_keys(configs), '\\|'))
        vim.fn.matchadd("Error", "cmd not defined\\|"..cmd_not_found_msg)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<esc>', '<cmd>bd<CR>', { noremap = true})
        vim.lsp.util.close_preview_autocmd({"BufHidden", "BufLeave"}, win_id)
      end;
      "-nargs=?";
      description = '`:LspInfo` Displays info on currently configured and currently active servers';
    };
    LspInstall = {
      function()
        print("deprecated, see https://github.com/neovim/neovim/wiki/Following-HEAD")
      end;
      "-nargs=?";
      "-complete=custom,v:lua.lsp_complete_installable_servers";
      description = '`:LspInstall {name}` installs a server under stdpath("cache")/lspconfig/{name}';
    };
    LspInstallInfo = {
      function()
        print("deprecated, see https://github.com/neovim/neovim/wiki/Following-HEAD")
      end;
      "-nargs=?";
      "-complete=custom,v:lua.lsp_complete_servers";
      description = 'Print installation info for {name} if one is specified, or all installable servers.';
    };
  };

  M.util.create_module_commands("_root", M._root.commands)
end

local mt = {}
function mt:__index(k)
  if configs[k] == nil then
    require('lspconfig/'..k)
  end
  return configs[k]
end

return setmetatable(M, mt)
-- vim:et ts=2 sw=2
