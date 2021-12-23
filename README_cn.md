# lspconfig

Neovim 内置[语言服务器客户端](https://neovim.io/doc/user/lsp.html)的[常见配置集合](doc/server_configurations.md)。

此插件允许声明性地配置、启动和初始化您在系统上安装的语言服务器。

**免责声明：语言服务器配置是尽最大努力提供的，并由社区维护。见[贡献](#贡献)。**

`lspconfig` 有广泛的帮助文档，请参阅 `:help lspconfig`。

# LSP 概述

Neovim 支持语言服务器协议（LSP），这意味着它充当语言服务器的客户端，并包含用于构建增强的 LSP 工具的 Lua 框架 `vim.lsp`。LSP 促进以下功能：

- 查找定义（go-to-definition）
- 查找参考（find-references）
- hover
- 完成（completion）
- 重命名（rename）
- 格式化（format）
- 重构（refactor）

Neovim 为所有这些功能提供了一个接口，语言服务器客户端旨在高度扩展，允许插件集成 Neovim 核心中尚未存在的语言服务器功能，如[**自动**完成](https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion)（而不是使用 omnifunc 手动完成）和[片段集成](https://github.com/neovim/nvim-lspconfig/wiki/Snippets)。

这些功能不是在这个仓库中实现的，而是在 Neovim 核心中实现的。有关更多详细信息，请参阅 `:help lsp`。

## 安装

* 需要 [Neovim v0.6.0](https://github.com/neovim/neovim/releases/tag/v0.6.0) 或 [Nightly](https://github.com/neovim/neovim/releases/tag/nightly)。在报告问题之前请更新 Neovim 和“lspconfig”。

* 安装“lspconfig”和其他 Vim 插件一样，例如使用 [vim-plug](https://github.com/junegunn/vim-plug)：

    ```vim
    Plug 'neovim/nvim-lspconfig'
    ```

## 快速入门

1. 安装语言服务器，例如 [pyright](doc/server_configurations.md#pyright)

    ```bash
    npm i -g pyright
    ```

2. 将语言服务器设置添加到您的 `init.vim` 中。服务器名称必须与 [server_configurations.md](doc/server_configurations.md) 目录中的名称匹配。此列表也可以通过 `:help lspconfig-server-configurations` 访问。

    ```lua
    lua << EOF
    require'lspconfig'.pyright.setup{}
    EOF
    ```

3. 创建项目，此项目必须包含与根目录触发器匹配的文件。有关更多信息，请参阅[自动启动语言服务器](#自动启动语言服务器)。

    ```bash
    mkdir test_python_project
    cd test_python_project
    git init
    touch main.py
    ```

4. 启动 Neovim，语言服务器现在将附加并提供诊断程序（请参阅 `:LspInfo`）

    ```
    nvim main.py
    ```

5. 有关映射有用功能和启用全能完成，请参阅[键绑定和完成](#键绑定和完成)

## 自动启动语言服务器

为了自动启动语言服务器，“lspconfig”从当前缓冲区搜索目录树，以找到与每个服务器配置中定义的 `root_dir` 模式匹配的文件。对于 [pyright](doc/server_configurations.md#pyright)，这是包含“.git”、“setup.py”、“setup.cfg”、“pyproject.toml”或“requirements.txt”的任何目录。

语言服务器要求每个项目都有一个 `根目录`，以便在当前文件中可能无法定义的符号之间提供完成和搜索，并避免在每次启动时对整个文件系统进行索引。

启用大多数语言服务器就像安装语言服务器一样简单，确保它在您的 `PATH` 上，并在配置中添加以下内容：

```vim
lua << EOF
require'lspconfig'.rust_analyzer.setup{}
EOF
```

有关服务器的完整列表，请参阅 [server_configurations.md](doc/server_configurations.md) 或 `:help lspconfig-server-configurations`。本文包含每种语言服务器的安装说明和额外的可选自定义建议。对于一些不在系统路径上的服务器（例如 `jdtls`、`elixirls`），您将需要在传递给设置的表中手动添加 `cmd` 作为条目。大多数语言服务器可以在一分钟内安装。

## 键绑定和完成

默认情况下，“lspconfig”不会映射键绑定或启用完成。手动触发完成可以通过 neovim 的内置 omnifunc 提供。对于自动完成，需要一个通用的[自动完成插件](https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion)。以下示例配置为最常用的语言服务器函数提供了建议的键映射，并使用 omnifunc（\<c-x\>\<c-o\>）手动触发完成。

注意：**您必须将定义的 `on_attach` 作为参数传递给每个 `setup {}` 调用**，并且 **`on_attach` 中的键绑定仅在语言服务器启动后（连接到当前缓冲区）生效**。

```lua
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF
```

`on_attach` 钩子仅用于在语言服务器连接到当前缓冲区后激活绑定。

## 调试

如果您在使用“lspconfig”时遇到问题，第一步是以[最小的配置](https://github.com/neovim/nvim-lspconfig/blob/master/test/minimal_init.lua)进行重现。

语言服务器不启动或附加的最常见原因是：

1. 未安装语言服务器。“lspconfig”不会为您安装语言服务器。您应该能够从命令行运行每个服务器的 lua 模块中定义的 `cmd`，并查看语言服务器是否启动。如果 `cmd` 是一个可执行名称，请确保它在您的路径上。

2. 不触发根检测。语言服务器只有在目录或子目录中打开时才会启动，该目录包含一个为项目*根*指示的文件。大多数时候，这是一个 `.git` 文件夹，但每个服务器都在 lua 文件中定义根配置。有关根目录列表，请参阅 [server_configurations.md](doc/server_configurations.md) 或源代码。

3. 配置错误。如果您希望**每个** `setup {}` 生效，您必须传递 `on_attach` 和 `capabilities`。您也 **不得为同一服务器调用 `setup {}` 两次**。`setup {}` 的第二次调用将覆盖第一次。

`:LspInfo` 提供了您已经激活和配置的语言服务器的便捷概述。请注意，它不会报告在 `on_new_config` 中应用的任何配置更改。

在报告错误之前，请检查日志和 `:LspInfo` 的输出。将以下内容添加到您的 `init.vim` 中以启用日志记录：

```lua
lua << EOF
vim.lsp.set_log_level("debug")
EOF
```

尝试运行语言服务器，并使用以下命令打开日志：

```
:lua vim.cmd('e'..vim.lsp.get_log_path())
```

大多数情况下，故障的原因存在于日志中。

## 内置命令

* `:LspInfo` 显示活动和已配置语言服务器的状态。

以下支持所有参数的制表符完成：

* `:LspStart <config_name>` 启动请求的服务器名称。只有当命令检测到与当前配置匹配的根目录时，才会成功启动。如果您希望仅使用此命令启动客户端，请将 `autostart = false` 传递给您的 `.setup{}` 语言服务器调用。默认为与当前缓冲区文件类型匹配的所有服务器。
* `:LspStop <client_id>` 默认停止所有缓冲区客户端。
* `:LspRestart <client_id>` 默认为重新启动所有缓冲区客户端。

## 维基

有关其他主题，请参阅[维基](https://github.com/neovim/nvim-lspconfig/wiki)，包括：

* [自动安装语言服务器](https://github.com/neovim/nvim-lspconfig/wiki/Installing-language-servers-automatically)
* [片段支持](https://github.com/neovim/nvim-lspconfig/wiki/Snippets)
* [项目本地设置](https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings)
* [增强语言服务器功能的推荐插件](https://github.com/neovim/nvim-lspconfig/wiki/Language-specific-plugins)

## 贡献

如果您在 [server_configurations.md](doc/server_configurations.md) 中缺少列表中的语言服务器，我们将不胜感激为其提供新的配置。您可以按照以下步骤操作：

1. 阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。

2. 从 [coc.nvim 维基](https://github.com/neoclide/coc.nvim/wiki/Language-servers)或 [emacs-lsp](https://github.com/emacs-lsp/lsp-mode#supported-languages) 中选择一种语言。

3. 在 `lua/lspconfig/SERVER_NAME.lua` 创建一个新文件。

    - 复制[现有配置](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/)来开始。大多数配置很简单。有关广泛的例子，请参阅 [texlab.lua](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/texlab.lua)。

4. 在我们 [Discourse](https://neovim.discourse.group/c/7-category/7) 或 [Neovim Gitter](https://gitter.im/neovim/neovim) 中提问。

您还可以通过测试[“带有需求测试（`needs-testing`）”标签的 PR](https://github.com/neovim/nvim-lspconfig/issues?q=is%3Apr+is%3Aopen+label%3Aneeds-testing) 来提供帮助, 这些 PR 会影响您经常使用的语言服务器。
