local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'
local luv = vim.loop

local name = 'clangd'

local github_release_url = 'https://api.github.com/repos/clangd/clangd/releases/latest'

local platform_translation = {windows_nt = 'windows',linux = 'linux',darwin = 'mac'}


local function get_system_info()
    local info =  luv.os_uname()
    return info.sysname:lower(),info.machine
end

-- fetch latest release info
local function get_latest_release_info()
  local f = io.popen("curl -k --silent '"..github_release_url.."' ")
  local l = f:read("*a")
  f:close()
  return vim.fn.json_decode(l)
end

-- get latest download url,filename for OS
local function parse_clangd_download_info(json_response,system)
  local assets = json_response['assets']
  for _,asset in ipairs(assets) do
      if string.match(asset['name'], system) then
          return asset['browser_download_url'],asset['name']
      end
  end
  error('No release for the current system')
end

local function passes_installation_checks(install_info,system,architecture)
    if install_info.is_installed then
      print(name, "is already installed")
      return false
    end

    -- TODO:Is this check required?
    if  architecture ~= 'x86_64' then
      error("no release for this architecture "..architecture)
      return false
    end

    -- TODO: Might need to check glibc version on linux
    if not platform_translation[system] then
      error("Unsupported platform "..system)
      return false
    end

    if not (util.has_bins("curl")) then
      error('Need "curl" to install this.')
      return false
    end

    if (system == 'darwin' or system == 'linux') and not util.has_bins('unzip') then
      error("unzip is required on "..system)
      return false
    end

    if system == 'windows_nt' and not util.has_bins('Expand-Archive') then
      error("Expand-Archive is required on "..system)
      return false
    end

    return true
end

local function make_installer()
  local P = util.path.join
  local install_dir = P{util.base_install_dir , name}

  local bin = P{install_dir , "bin","clangd"}

  local X = {}
  function X.install()
    -- TODO: test installation on windows?
    local install_info = X.info()
    local system,architecture = get_system_info()

    if not passes_installation_checks(install_info, system , architecture) then
      return;
    end

    local release_info = get_latest_release_info()
    local release_version = release_info.name
    local download_url,zip_file_name = parse_clangd_download_info(release_info, platform_translation[system])
    local zip_file_path = P{install_info.install_dir , zip_file_name}
    local download_cmd = string.format("curl -fLo %s --create-dirs '%s'",zip_file_path , download_url)
    local target_bin_dir = P{install_info.install_dir,name..'_'..release_version,'bin'}
    local symlink_dir = P{install_info.install_dir,'bin'}
    local install_cmd = ''

    -- install_dir:
    --            /clangd-<version>.zip
    --            /clangd_<version>/
    --                              bin/clangd
    --            /bin  -> ./clangd_<version>/bin

    if system == 'darwin' or system == 'linux' then
      install_cmd = "unzip "..zip_file_path.." -d "..install_info.install_dir
    elseif system == 'windows_nt' then
      install_cmd = "Expand-Archive -Force "..zip_file_path.." -d "..install_info.install_dir
    end

    vim.fn.system(download_cmd)
    vim.fn.system(install_cmd)
    util.fs.force_symlink(target_bin_dir, symlink_dir, function(err) if( err ) then error(err) end end)
  end

  function X.info()
    return {
      is_installed = util.has_bins(name) or util.path.exists(bin);
      install_dir = install_dir;
      cmd = {util.has_bins(name) and name or bin , "--background-index"};
    }
  end

  function X.configure(config)
    local install_info = X.info()
    if install_info.is_installed then
      config.cmd = install_info.cmd
    end
  end
  return X
end

local installer = make_installer()



-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  vim.lsp.buf_request(bufnr, 'textDocument/switchSourceHeader', params, function(err, _, result)
    if err then error(tostring(err)) end
    if not result then print ("Corresponding file can’t be determined") return end
    vim.api.nvim_command('edit '..vim.uri_to_fname(result))
  end)
end

local root_pattern = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")
configs[name] = {
  default_config = util.utf8_config {
    filetypes = {"c", "cpp", "objc", "objcpp"};
    root_dir = function(fname)
      local filename = util.path.is_absolute(fname) and fname
        or util.path.join(vim.loop.cwd(), fname)
      return root_pattern(filename) or util.path.dirname(filename)
    end;
    capabilities = {
      textDocument = {
        completion = {
          editsNearCursor = true
        }
      }
    },
  };
  on_new_config = function(config)
    installer.configure(config)
  end;
  commands = {
    ClangdSwitchSourceHeader = {
      function()
        switch_source_header(0)
      end;
      description = "Switch between source/header";
    };
  };
  docs = {
    description = [[
https://clang.llvm.org/extra/clangd/Installation.html

**NOTE:** Clang >= 9 is recommended! See [this issue for more](https://github.com/neovim/nvim-lsp/issues/23).

clangd relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
as compile_commands.json or, for simpler projects, a compile_flags.txt.
For details on how to automatically generate one using CMake look [here](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html).
]];
    default_config = {
      root_dir = [[root_pattern("compile_commands.json", "compile_flags.txt", ".git") or dirname]];
      on_init = [[function to handle changing offsetEncoding]];
      capabilities = [[default capabilities, with offsetEncoding utf-8]];
    };
  };
}

configs[name].switch_source_header = switch_source_header
configs[name].install = installer.install
configs[name].install_info = installer.info
-- vim:et ts=2 sw=2
