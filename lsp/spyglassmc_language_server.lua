---@brief
---
--- https://github.com/SpyglassMC/Spyglass/tree/main/packages/language-server
---
--- Language server for Minecraft datapacks.
---
--- `spyglassmc-language-server` can be installed via `npm`:
---
--- ```sh
--- npm i -g @spyglassmc/language-server
--- ```
---
--- You may also need to configure the filetype:
---
--- `autocmd BufNewFile,BufRead *.mcfunction set filetype=mcfunction`
---
--- This is automatically done by [CrystalAlpha358/vim-mcfunction](https://github.com/CrystalAlpha358/vim-mcfunction), which also provide syntax highlight.
return {
  cmd = { 'spyglassmc-language-server', '--stdio' },
  filetypes = { 'mcfunction' },
  root_markers = { 'pack.mcmeta' },
}
