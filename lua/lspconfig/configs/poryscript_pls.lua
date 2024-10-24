local util = require('lspconfig.util')

return {
  default_config = {
    cmd = { 'poryscript-pls' },
    filetypes = { 'pory' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/huderlem/poryscript-pls

Language server for poryscript (a high level scripting language for GBA-era Pokémon decompilation projects)
    ]],
  },
}
