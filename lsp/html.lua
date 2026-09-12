---@brief
---
--- https://github.com/hrsh7th/vscode-langservers-extracted
---
--- `vscode-html-language-server` can be installed via `npm`:
--- ```sh
--- npm i -g vscode-langservers-extracted
--- ```
---
--- Neovim does not currently include built-in snippets. `vscode-html-language-server` only provides completions when snippet support is enabled.
--- To enable completion, install a snippet plugin and add the following override to your language client capabilities during setup.
---
--- The code-formatting feature of the lsp can be controlled with the `provideFormatter` option.
---
--- ```lua
--- --Enable (broadcasting) snippet capability for completion
--- local capabilities = vim.lsp.protocol.make_client_capabilities()
--- capabilities.textDocument.completion.completionItem.snippetSupport = true
---
--- vim.lsp.config('html', {
---   capabilities = capabilities,
--- })
--- ```

local function get_cmd(cmd, root_dir)
  if not root_dir then
    return cmd
  end

  local lockfiles = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  local workspace_root = vim.fs.root(root_dir, lockfiles) or vim.fs.root(root_dir, '.git') or root_dir
  local dir = root_dir
  while dir do
    local local_cmd = vim.fs.joinpath(dir, 'node_modules/.bin', cmd)
    if vim.fn.executable(local_cmd) == 1 then
      return local_cmd
    end
    if dir == workspace_root then
      break
    end
    dir = vim.fs.dirname(dir)
  end
  return cmd
end

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = get_cmd('vscode-html-language-server', (config or {}).root_dir)
    return vim.lsp.rpc.start({ cmd, '--stdio' }, dispatchers)
  end,
  filetypes = { 'html' },
  root_markers = { 'package.json', '.git' },
  ---@type lspconfig.settings.html
  settings = {},
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { 'html', 'css', 'javascript' },
  },
}
