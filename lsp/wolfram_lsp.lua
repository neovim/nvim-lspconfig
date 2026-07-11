---@brief
---
--- https://github.com/WolframResearch/LSPServer
---
--- LSPServer is an official lsp server for Mathematica.
---
--- Installation:
--- The LSPServer paclet and its dependencies are included in Mathematica or
--- Wolfram Engine installation in recent versions (13.0 and later).
---
--- If your Mathematica or Wolfram Engine installation is old and LSPServer is
--- not included, you can install it manually in a Mathematica environment:
--- ```mma
--- PacletInstall["CodeParser"]
--- PacletInstall["CodeInspector"]
--- PacletInstall["CodeFormatter"]
--- PacletInstall["LSPServer"]
--- ```

---@type vim.lsp.Config
return {
  -- CMD is borrowed from official vscode extension:
  -- https://github.com/WolframResearch/vscode-wolfram
  cmd = {
    'WolframKernel',
    '-noinit',
    '-noprompt',
    '-nopaclet',
    '-noicon',
    '-nostartuppaclets',
    '-run',
    'Needs["LSPServer`"];LSPServer`StartServer[]',
  },
  filetypes = { 'mma' },
  root_markers = { '.git' },
  init_options = {
    -- The semantic tokens support needs to be explicitly enabled.
    -- Otherwise, there would be errors during lsp initialization such as:
    --   "attempt to index field 'semanticTokensProvider' (a userdata value)"
    --
    -- Option found in:
    -- https://github.com/WolframResearch/LSPServer/blob/cecb4b310270d39fb7ba05564e5d5ae89d27802d/LSPServer/Kernel/LSPServer.wl#L926
    semanticTokens = true,
  },
}
