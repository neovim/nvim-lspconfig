-- vim: ft=lua tw=80

-- Rerun tests only if their modification time changed.
cache = true

ignore = {
  "212", -- Unused argument, In the case of callback function, _arg_name is easier to understand than _, so this option is set to off.
  "631", -- max_line_length, vscode pkg URL is too long
}

-- Global objects defined by the C code
read_globals = {
  vim = {
    fields = {
      -- :help lua-vim-variables
      g = { read_only = false, other_fields = true },
      b = { read_only = false, other_fields = true },
      w = { read_only = false, other_fields = true },
      t = { read_only = false, other_fields = true },
      v = { read_only = false, other_fields = true },
      env = { read_only = false, other_fields = true },

      -- :help lua-vim-options
      o = { read_only = false, other_fields = true },
      bo = { read_only = false, other_fields = true },
      wo = { read_only = false, other_fields = true },

      api = {
        fields = {
          "nvim_buf_get_lines",
          "nvim_buf_get_option",
          "nvim_buf_set_keymap",
          "nvim_buf_set_lines",
          "nvim_buf_set_option",
          "nvim_command",
          "nvim_get_current_buf",
          "nvim_list_bufs",
          "nvim_win_set_buf",
        }
      },

      fn = { other_fields = true },

      lsp = {
        fields = {
          handlers = { read_only = false, other_fields = true },

          protocol = {
            fields = {
              MessageType = {
                fields = {
                  "Error",
                  "Info",
                  "Log",
                  "Warning",
                }
              },

              "make_client_capabilities"
            }
          },

          util = {
            fields = {
              "_trim_and_pad",
              "close_preview_autocmd",
            }
          },

          "_cmd_parts",
          "buf_get_clients",
          "buf_request",
          "buf_request_sync",
          "get_active_clients",
          "set_log_level",
        }
      },

      types = {
        fields = {
          "dictionary",
        }
      },

      "cmd",
      "deepcopy",
      "empty_dict",
      "list_extend",
      "loop",
      "schedule_wrap",
      "split",
      "tbl_add_reverse_lookup",
      "tbl_deep_extend",
      "tbl_extend",
      "tbl_flatten",
      "tbl_isempty",
      "tbl_islist",
      "tbl_keys",
      "type_idx",
      "uri_from_bufnr",
      "uri_to_bufnr",
      "uri_to_fname",
      "validate",
    }
  }
}
