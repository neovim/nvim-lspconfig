return {
  default_config = {
    cmd = { 'hlasm_language_server' },
    filetypes = { 'hlasm' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.hlasmplugin' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
    `hlasm_language_server` is a language server for the High Level Assembler language used on IBM SystemZ mainframes.

    To learn how to configure the HLASM language server, see the [HLASM Language Support documentation](https://github.com/eclipse-che4z/che-che4z-lsp-for-hlasm).
    ]],
  },
}
