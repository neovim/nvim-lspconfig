local root = vim.fn.getcwd()

describe('lspconfig', function()
  --- @diagnostic disable-next-line:undefined-field
  local eq = assert.are.equal
  --- @diagnostic disable-next-line:undefined-field
  local same = assert.are.same

  before_each(function()
    vim.api.nvim_command('cd ' .. root)
  end)

  describe('util', function()
    describe('root_pattern', function()
      it('resolves to a_marker.txt', function()
        local lspconfig = require 'lspconfig'
        -- change the working directory to test directory
        vim.api.nvim_command 'cd ./test/test_dir/a'
        local cwd = vim.fn.getcwd()
        eq(true, cwd == lspconfig.util.root_pattern { 'a_marker.txt', 'root_marker.txt' }(cwd))
      end)

      it('resolves to root_marker.txt', function()
        local lspconfig = require 'lspconfig'

        -- change the working directory to test directory
        vim.api.nvim_command 'cd ./test/test_dir/a'

        local cwd = vim.fn.getcwd()
        local resolved = lspconfig.util.root_pattern { 'root_marker.txt' }(cwd)
        vim.api.nvim_command 'cd ..'

        eq(true, vim.fn.getcwd() == resolved)
      end)
    end)

    describe('strip_archive_subpath', function()
      it('strips zipfile subpaths', function()
        local lspconfig = require 'lspconfig'
        local res = lspconfig.util.strip_archive_subpath 'zipfile:///one/two.zip::three/four'
        eq('/one/two.zip', res)
      end)

      it('strips tarfile subpaths', function()
        local lspconfig = require 'lspconfig'
        local res = lspconfig.util.strip_archive_subpath 'tarfile:/one/two.tgz::three/four'
        eq('/one/two.tgz', res)
      end)

      it('returns non-archive paths as-is', function()
        local lspconfig = require 'lspconfig'
        local res = lspconfig.util.strip_archive_subpath '/one/two.zip'
        eq('/one/two.zip', res)
      end)
    end)

    describe('user commands', function()
      it('should translate command definition to nvim_create_user_command options', function()
        local util = require 'lspconfig.util'
        local res = util._parse_user_command_options {
          function() end,
          '-nargs=* -complete=custom,v:lua.some_global',
        }

        same({
          nargs = '*',
          complete = 'custom,v:lua.some_global',
        }, res)

        res = util._parse_user_command_options {
          function() end,
          ['-nargs'] = '*',
          '-complete=custom,v:lua.another_global',
          description = 'My awesome description.',
        }
        same({
          desc = 'My awesome description.',
          nargs = '*',
          complete = 'custom,v:lua.another_global',
        }, res)
      end)
    end)
  end)

  describe('config', function()
    it('normalizes user, server, and base default configs', function()
      local lspconfig = require 'lspconfig'
      local configs = require 'lspconfig.configs'

      local actual = nil
      lspconfig.util.on_setup = function(config)
        actual = config
      end

      lspconfig.util.default_config = {
        foo = {
          bar = {
            val1 = 'base1',
            val2 = 'base2',
          },
        },
      }

      local server_config = {
        default_config = {
          foo = {
            bar = {
              val2 = 'server2',
              val3 = 'server3',
            },
            baz = 'baz',
          },
        },
      }

      local user_config = {
        foo = {
          bar = {
            val3 = 'user3',
            val4 = 'user4',
          },
        },
      }

      configs['test'] = server_config
      configs['test'].setup(user_config)
      same({
        foo = {
          bar = {
            val1 = 'base1',
            val2 = 'server2',
            val3 = 'user3',
            val4 = 'user4',
          },
          baz = 'baz',
        },
        name = 'test',
      }, actual)
      configs['test'] = nil
    end)

    it("excludes indexed server configs that haven't been set up", function()
      local lspconfig = require 'lspconfig'
      local _ = lspconfig.lua_ls
      local _ = lspconfig.tsserver
      lspconfig.rust_analyzer.setup {}
      same({ 'rust_analyzer' }, require('lspconfig.util').available_servers())
    end)

    it('provides user_config to the on_setup hook', function()
      local lspconfig = require 'lspconfig'
      local util = require 'lspconfig.util'
      local user_config
      util.on_setup = function(_, conf)
        user_config = conf
      end
      lspconfig.rust_analyzer.setup { custom_user_config = 'custom' }
      same({
        custom_user_config = 'custom',
      }, user_config)
    end)
  end)

  describe('termux_language_server', function()
    local function with_publish_diagnostics_stub(stub, fn)
      local orig = vim.lsp.handlers['textDocument/publishDiagnostics']
      vim.lsp.handlers['textDocument/publishDiagnostics'] = stub
      local ok, err = pcall(fn)
      vim.lsp.handlers['textDocument/publishDiagnostics'] = orig
      if not ok then
        error(err, 0)
      end
    end

    it('sets default diagnostic source when missing, vim.NIL, or empty', function()
      local config = dofile(root .. '/lsp/termux_language_server.lua')
      local handler = config.handlers['textDocument/publishDiagnostics']
      local forwarded_result

      with_publish_diagnostics_stub(function(_, result)
        forwarded_result = result
      end, function()
        handler(nil, {
          uri = 'file:///tmp/PKGBUILD',
          diagnostics = {
            { message = 'missing source' },
            { message = 'null source', source = vim.NIL },
            { message = 'empty source', source = '' },
          },
        }, { method = 'textDocument/publishDiagnostics', client_id = 1 })
      end)

      eq('termux-language-server', forwarded_result.diagnostics[1].source)
      eq('termux-language-server', forwarded_result.diagnostics[2].source)
      eq('termux-language-server', forwarded_result.diagnostics[3].source)
    end)

    it('preserves existing non-empty diagnostic source', function()
      local config = dofile(root .. '/lsp/termux_language_server.lua')
      local handler = config.handlers['textDocument/publishDiagnostics']
      local forwarded_result

      with_publish_diagnostics_stub(function(_, result)
        forwarded_result = result
      end, function()
        handler(nil, {
          uri = 'file:///tmp/PKGBUILD',
          diagnostics = {
            { message = 'from namcap', source = 'namcap' },
            { message = 'without source' },
          },
        }, { method = 'textDocument/publishDiagnostics', client_id = 1 })
      end)

      eq('namcap', forwarded_result.diagnostics[1].source)
      eq('termux-language-server', forwarded_result.diagnostics[2].source)
    end)

    it('forwards all arguments and return value for nil and empty results', function()
      local config = dofile(root .. '/lsp/termux_language_server.lua')
      local handler = config.handlers['textDocument/publishDiagnostics']
      local calls = {}

      with_publish_diagnostics_stub(function(err, result, ctx, cfg)
        table.insert(calls, { err = err, result = result, ctx = ctx, cfg = cfg })
        return 'forwarded'
      end, function()
        local sample_err = { code = -32603, message = 'internal error' }
        local sample_ctx = { method = 'textDocument/publishDiagnostics', client_id = 42 }
        local sample_cfg = { underline = false }

        local ret1 = handler(sample_err, nil, sample_ctx, sample_cfg)
        local ret2 = handler(nil, {}, sample_ctx, sample_cfg)

        eq('forwarded', ret1)
        eq('forwarded', ret2)
        eq(2, #calls)
        same(sample_err, calls[1].err)
        eq(nil, calls[1].result)
        same(sample_ctx, calls[1].ctx)
        same(sample_cfg, calls[1].cfg)
        eq(nil, calls[2].err)
        same({}, calls[2].result)
        same(sample_ctx, calls[2].ctx)
        same(sample_cfg, calls[2].cfg)
      end)
    end)

    it('populates vim.diagnostic source and user_data via real Neovim handler', function()
      local config = dofile(root .. '/lsp/termux_language_server.lua')
      local handler = config.handlers['textDocument/publishDiagnostics']
      local bufnr = vim.api.nvim_create_buf(false, true)

      local ok, err = pcall(function()
        vim.api.nvim_buf_set_name(bufnr, vim.fn.tempname() .. '_PKGBUILD')
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { 'pkgname=foo', 'pkgver=1.0' })
        local uri = vim.uri_from_bufnr(bufnr)
        local ctx = { method = 'textDocument/publishDiagnostics', client_id = 999 }

        handler(nil, {
          uri = uri,
          diagnostics = {
            {
              range = {
                start = { line = 0, character = 0 },
                ['end'] = { line = 0, character = 7 },
              },
              message = 'missing pkgrel',
              severity = 2,
            },
          },
        }, ctx)

        local diags = vim.diagnostic.get(bufnr)
        eq(1, #diags)
        eq('termux-language-server', diags[1].source)
        eq('termux-language-server', diags[1].user_data.lsp.source)

        handler(nil, {
          uri = uri,
          diagnostics = {},
        }, ctx)

        eq(0, #vim.diagnostic.get(bufnr))
      end)

      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
      if not ok then
        error(err, 0)
      end
    end)
  end)
end)
