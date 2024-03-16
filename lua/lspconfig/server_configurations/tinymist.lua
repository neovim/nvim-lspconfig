return {
  default_config = {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
    root_dir = function()
      return vim.fn.getcwd()
    end,
  },
  docs = {
    description = [[
https://github.com/Myriad-Dreamin/tinymist
An integrated language service for Typst [taɪpst]. You can also call it "微霭" [wēi ǎi] in Chinese.
    ]],
  },
}
