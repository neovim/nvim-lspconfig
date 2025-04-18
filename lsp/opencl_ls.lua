---@brief
---
--- https://github.com/Galarius/opencl-language-server
---
--- Build instructions can be found [here](https://github.com/Galarius/opencl-language-server/blob/main/_dev/build.md).
---
--- Prebuilt binaries are available for Linux, macOS and Windows [here](https://github.com/Galarius/opencl-language-server/releases).
return {
  cmd = { 'opencl-language-server' },
  filetypes = { 'opencl' },
  root_markers = { '.git' },
}
