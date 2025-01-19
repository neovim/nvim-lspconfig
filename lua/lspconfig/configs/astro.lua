local function get_typescript_server_path(root_dir)
  local project_root = vim.fs.find('node_modules', { path = root_dir, upward = true })[1]
  return project_root and (project_root .. '/typescript/lib') or ''
end

return {
  default_config = {
    cmd = { 'astro-ls', '--stdio' },
    filetypes = { 'astro' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find({ 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }, { path = fname, upward = true })[1]
      )
    end,
    init_options = {
      typescript = {},
    },
    on_new_config = function(new_config, new_root_dir)
      if vim.tbl_get(new_config.init_options, 'typescript') and not new_config.init_options.typescript.tsdk then
        new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
      end
    end,
  },
  docs = {
    description = [[
https://github.com/withastro/language-tools/tree/main/packages/language-server

`astro-ls` can be installed via `npm`:
```sh
npm install -g @astrojs/language-server
```
]],
  },
}
