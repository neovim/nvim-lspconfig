---@brief
---
--- https://github.com/haskell/haskell-ide-engine
---
--- the following init_options are supported (see https://github.com/haskell/haskell-ide-engine#configuration):
--- ```lua
--- init_options = {
---   languageServerHaskell = {
---     hlintOn = bool;
---     maxNumberOfProblems = number;
---     diagnosticsDebounceDuration = number;
---     liquidOn = bool (default false);
---     completionSnippetsOn = bool (default true);
---     formatOnImportOn = bool (default true);
---     formattingProvider = string (default "brittany", alternate "floskell");
---   }
--- }
--- ```
return {
  cmd = { 'hie-wrapper', '--lsp' },
  filetypes = { 'haskell' },
  root_markers = { 'stack.yaml', 'package.yaml', '.git' },
}
