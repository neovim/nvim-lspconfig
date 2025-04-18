---@brief
---
--- https://pypi.org/project/nginx-language-server/
---
--- `nginx-language-server` can be installed via pip:
---
--- ```sh
--- pip install -U nginx-language-server
--- ```
return {
  cmd = { 'nginx-language-server' },
  filetypes = { 'nginx' },
  root_markers = { 'nginx.conf', '.git' },
}
