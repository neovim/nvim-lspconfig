---@brief
---
--- https://github.com/quarylabs/sqruff
---
--- `sqruff` can be installed by following the instructions [here](https://github.com/quarylabs/sqruff?tab=readme-ov-file#installation)
---
return {
  cmd = { 'sqruff', 'lsp' },
  filetypes = { 'sql' },
  root_markers = { '.sqruff', '.git' },
}
