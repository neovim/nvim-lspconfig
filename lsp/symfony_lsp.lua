---@brief
---
--- https://github.com/symfony/language-tools
---
--- Symfony-aware completion, navigation, references, diagnostics, code actions,
--- rename support and code lenses alongside a general PHP language server.
---
--- Install the `symfony-lsp` executable from a release, then make it
--- available on `PATH`.
---
--- The server asks before executing application code for runtime indexing. Set
--- `init_options.workspaceTrust` explicitly only for trusted workspaces.

---@type vim.lsp.Config
return {
  cmd = { 'symfony-lsp' },
  filetypes = { 'php', 'twig', 'yaml', 'json', 'xml', 'javascript', 'typescript', 'env' },
  root_markers = { 'composer.json', '.git' },
  workspace_required = true,
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  init_options = {
    phpCommand = { 'php' },
    containerProjectRoot = '',
    consolePath = 'bin/console',
    environment = 'dev',
    debug = true,
    runtimeIndexing = true,
    projectRoots = {},
    trace = 'off',
  },
  settings = {
    symfonyLsp = {
      phpCommand = { 'php' },
      containerProjectRoot = '',
      consolePath = 'bin/console',
      environment = 'dev',
      debug = true,
      runtimeIndexing = true,
      projectRoots = {},
      translationDiagnostics = false,
    },
  },
  commands = {
    ['editor.action.showReferences'] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      local arguments = command.arguments or {}
      local uri = arguments[1]
      local position = arguments[2]
      local references = arguments[3]
      if type(uri) ~= 'string' or type(position) ~= 'table' or type(references) ~= 'table' then
        vim.notify('Symfony Language Tools returned an invalid reference command.', vim.log.levels.ERROR)
        return
      end

      local items = vim.lsp.util.locations_to_items(references, client.offset_encoding)
      vim.fn.setqflist({}, ' ', {
        title = command.title,
        items = items,
        context = {
          command = command,
          bufnr = ctx.bufnr,
        },
      })
      vim.lsp.util.show_document({
        uri = uri,
        range = {
          start = position,
          ['end'] = position,
        },
      }, client.offset_encoding)
      vim.cmd('botright copen')
    end,
  },
}
