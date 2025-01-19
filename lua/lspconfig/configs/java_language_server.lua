return {
  default_config = {
    filetypes = { 'java' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find({ 'build.gradle', 'build.gradle.kts', 'pom.xml', '.git' }, { path = fname, upward = true })[1]
      )
    end,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/georgewfraser/java-language-server

Java language server

Point `cmd` to `lang_server_linux.sh` or the equivalent script for macOS/Windows provided by java-language-server
]],
  },
}
