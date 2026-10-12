---@brief
---
--- https://github.com/typed-ember/glint
--- https://typed-ember.gitbook.io/glint/
--- `glint-language-server` is installed when adding `@glint/core` to your project's devDependencies:
---
--- ```sh
--- npm install @glint/core --save-dev
--- yarn add -D @glint/core
---
--- This configuration uses the local installation of `glint-language-server`
--- (found in the `node_modules` directory of your project).
---
--- To use a global installation of `glint-language-server`,
--- set the `init_options.glint.useGlobal` to `true`.
---
--- vim.lsp.config('glint', {
---   init_options = {
---     glint = {
---       useGlobal = true,
---     },
---   },
--- })

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
    local cmd = 'glint-language-server'
    ---@diagnostic disable-next-line: undefined-field
    if not config.init_options.glint.useGlobal then
      cmd = get_cmd(cmd, (config or {}).root_dir)
    end
    return vim.lsp.rpc.start({ cmd }, dispatchers)
  end,
  init_options = {
    glint = {
      useGlobal = false,
    },
  },
  filetypes = {
    'html.handlebars',
    'handlebars',
    'typescript',
    'typescript.glimmer',
    'javascript',
    'javascript.glimmer',
  },
  root_markers = {
    '.glintrc.yml',
    '.glintrc',
    '.glintrc.json',
    '.glintrc.js',
    'glint.config.js',
    'package.json',
  },
  workspace_required = true,
}
