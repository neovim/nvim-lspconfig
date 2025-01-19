local root = vim.fn.getcwd()

describe('lspconfig', function()
  --- @diagnostic disable-next-line:undefined-field
  local same = assert.are.same

  before_each(function()
    vim.api.nvim_command('cd ' .. root)
  end)

  describe('util', function()
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
      same({ 'rust_analyzer' }, require('lspconfig.util')._available_servers())
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
end)
