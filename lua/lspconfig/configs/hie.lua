return {
  default_config = {
    cmd = { 'hie-wrapper', '--lsp' },
    filetypes = { 'haskell' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'stack.yaml', 'package.yaml', '.git' }, { path = fname, upward = true })[1])
    end,
  },

  docs = {
    description = [[
https://github.com/haskell/haskell-ide-engine

the following init_options are supported (see https://github.com/haskell/haskell-ide-engine#configuration):
```lua
init_options = {
  languageServerHaskell = {
    hlintOn = bool;
    maxNumberOfProblems = number;
    diagnosticsDebounceDuration = number;
    liquidOn = bool (default false);
    completionSnippetsOn = bool (default true);
    formatOnImportOn = bool (default true);
    formattingProvider = string (default "brittany", alternate "floskell");
  }
}
```
        ]],
  },
}
