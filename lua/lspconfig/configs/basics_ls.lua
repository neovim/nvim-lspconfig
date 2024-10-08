return {
  default_config = {
    cmd = { 'basics-language-server' },
    single_file_support = true,
    settings = {
      buffer = {
        enable = true,
        minCompletionLength = 4,
      },
      path = {
        enable = true,
      },
      snippet = {
        enable = false,
        sources = {},
      },
    },
  },
  docs = {
    description = [[
https://github.com/antonk52/basics-language-server/

Buffer, path, and snippet completion

```sh
npm install -g basics-language-server
```
]],
  },
}
