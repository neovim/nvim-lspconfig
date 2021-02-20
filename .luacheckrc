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
    }
  }
}
