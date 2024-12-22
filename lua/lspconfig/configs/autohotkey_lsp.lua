-- NOTE: AutoHotkey is used only on windows
local function get_autohotkey_path()
  local path = vim.fn.exepath('autohotkey.exe')
  return #path > 0 and path or ''
end

return {
  default_config = {
    cmd = { 'autohotkey_lsp', '--stdio' },
    filetypes = { 'autohotkey' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('package.json', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    autostart = true,
    flags = { debounce_text_changes = 500 },
    --capabilities = capabilities,
    --on_attach = custom_attach,
    init_options = {
      locale = 'en-us',
      InterpreterPath = get_autohotkey_path(),
      AutoLibInclude = 'All',
      CommentTags = '^;;\\s*(?<tag>.+)',
      CompleteFunctionParens = false,
      SymbolFoldinFromOpenBrace = false,
      Diagnostics = {
        ClassStaticMemberCheck = true,
        ParamsCheck = true,
      },
      ActionWhenV1IsDetected = 'Continue',
      FormatOptions = {
        array_style = 'expand',
        break_chained_methods = false,
        ignore_comment = false,
        indent_string = '\t',
        max_preserve_newlines = 2,
        brace_style = 'One True Brace',
        object_style = 'none',
        preserve_newlines = true,
        space_after_double_colon = true,
        space_before_conditional = true,
        space_in_empty_paren = false,
        space_in_other = true,
        space_in_paren = false,
        wrap_line_length = 0,
      },
    },
  },
  docs = {
    description = [[
https://github.com/thqby/vscode-autohotkey2-lsp

AutoHotkey v2.0 LSP implementation
    ]],
  },
}
