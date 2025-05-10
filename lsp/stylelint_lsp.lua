---@brief
---
--- https://github.com/bmatcuk/stylelint-lsp
---
--- `stylelint-lsp` can be installed via `npm`:
---
--- ```sh
--- npm i -g stylelint-lsp
--- ```
---
--- Can be configured by passing a `settings.stylelintplus` object to vim.lsp.config('stylelint_lsp'):
---
--- ```lua
--- vim.lsp.config('stylelint_lsp', {
---   settings = {
---     stylelintplus = {
---       -- see available options in stylelint-lsp documentation
---     }
---   }
--- })
--- ```

local root_markers = {
  '.stylelintrc',
  '.stylelintrc.mjs',
  '.stylelintrc.cjs',
  '.stylelintrc.js',
  '.stylelintrc.json',
  '.stylelintrc.yaml',
  '.stylelintrc.yml',
  'stylelint.config.mjs',
  'stylelint.config.cjs',
  'stylelint.config.js',
}

return {
  cmd = { 'stylelint-lsp', '--stdio' },
  filetypes = {
    'astro',
    'css',
    'html',
    'less',
    'scss',
    'sugarss',
    'vue',
    'wxss',
  },
  root_dir = function(bufnr, on_dir)
    local iswin = vim.uv.os_uname().version:match 'Windows'
    local package_json_dir = vim.fs.root(bufnr, 'package.json')

    -- Append `package.json` only if contains 'stylelint'
    if package_json_dir then
      local path_sep = iswin and '\\' or '/'
      for line in io.lines(package_json_dir .. path_sep .. 'package.json') do
        if line:find('stylelint') then
          root_markers[#root_markers + 1] = 'package.json'
        end
      end
    end

    on_dir(vim.fs.root(bufnr, root_markers))
  end,
  settings = {},
}
