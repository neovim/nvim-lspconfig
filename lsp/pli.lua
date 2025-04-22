---@brief
---
--- `pli_language_server` is a language server for the PL/I language used on IBM SystemZ mainframes.
---
--- To learn how to configure the PL/I language server, see the [PL/I Language Support documentation](https://github.com/zowe/zowe-pli-language-support).
return {
  cmd = { 'pli_language_server' },
  filetypes = { 'pli' },
  root_markers = { '.pliplugin' },
}
