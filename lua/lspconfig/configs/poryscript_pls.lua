return {
  default_config = {
    cmd = { 'poryscript-pls' },
    filetypes = { 'pory' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/huderlem/poryscript-pls

Language server for poryscript (a high level scripting language for GBA-era Pokémon decompilation projects)
    ]],
  },
}
