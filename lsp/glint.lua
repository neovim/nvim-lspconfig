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

function get_cmd()
  local useGlobal = vim.lsp.config.glint.init_options.glint.useGlobal
  if useGlobal then
    return { 'glint-language-server' }
  end

  local root_markers = vim.lsp.config.glint.root_markers
  local root_dir = vim.fs.root(0, root_markers)

  return { root_dir .. '/node_modules/.bin/glint-language-server' }
end

return {
  cmd = function(dispatchers)
    local cmd = get_cmd()
    return vim.lsp.rpc.start(cmd, dispatchers)
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
