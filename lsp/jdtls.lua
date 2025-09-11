---@brief
---
--- https://projects.eclipse.org/projects/eclipse.jdt.ls
---
--- Language server for Java.
---
--- IMPORTANT: If you want all the features jdtls has to offer, [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)
--- is highly recommended. If all you need is diagnostics, completion, imports, gotos and formatting and some code actions
--- you can keep reading here.
---
--- For manual installation you can download precompiled binaries from the
--- [official downloads site](http://download.eclipse.org/jdtls/snapshots/?d)
--- and ensure that the `PATH` variable contains the `bin` directory of the extracted archive.
---
--- ```lua
---   -- init.lua
---   vim.lsp.enable('jdtls')
--- ```
---
--- You can also pass extra custom jvm arguments with the JDTLS_JVM_ARGS environment variable as a space separated list of arguments,
--- that will be converted to multiple --jvm-arg=<param> args when passed to the jdtls script. This will allow for example tweaking
--- the jvm arguments or integration with external tools like lombok:
---
--- ```sh
--- export JDTLS_JVM_ARGS="-javaagent:$HOME/.local/share/java/lombok.jar"
--- ```
---
--- For automatic installation you can use the following unofficial installers/launchers under your own risk:
---   - [jdtls-launcher](https://github.com/eruizc-dev/jdtls-launcher) (Includes lombok support by default)
---     ```lua
---       -- init.lua
---       vim.lsp.config('jdtls', { cmd = { 'jdtls' } })
---     ```

local env = {
  HOME = vim.uv.os_homedir(),
  XDG_CACHE_HOME = os.getenv 'XDG_CACHE_HOME',
  JDTLS_JVM_ARGS = os.getenv 'JDTLS_JVM_ARGS',
}

local function get_cache_dir()
  return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or env.HOME .. '/.cache'
end

local function get_jdtls_cache_dir()
  return get_cache_dir() .. '/jdtls'
end

local function get_jdtls_config_dir()
  return get_jdtls_cache_dir() .. '/config'
end

local function get_jdtls_workspace_dir()
  return get_jdtls_cache_dir() .. '/workspace'
end

local function get_jdtls_jvm_args()
  local args = {}
  for a in string.gmatch((env.JDTLS_JVM_ARGS or ''), '%S+') do
    local arg = string.format('--jvm-arg=%s', a)
    table.insert(args, arg)
  end
  return unpack(args)
end

---@type vim.lsp.Config
return {
  cmd = {
    'jdtls',
    '-configuration',
    get_jdtls_config_dir(),
    '-data',
    get_jdtls_workspace_dir(),
    get_jdtls_jvm_args(),
  },
  filetypes = { 'java' },
  root_markers = {
    -- Multi-module projects
    '.git',
    'build.gradle',
    'build.gradle.kts',
    -- Single-module projects
    'build.xml', -- Ant
    'pom.xml', -- Maven
    'settings.gradle', -- Gradle
    'settings.gradle.kts', -- Gradle
  },
  init_options = {
    workspace = get_jdtls_workspace_dir(),
    jvm_args = {},
    os_config = nil,
  },
}
