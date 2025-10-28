describe('jdtls cmd helper', function()
  it('handles nil config by falling back to defaults', function()
    local jdtls = require 'lsp.jdtls'
    local original_start = vim.lsp.rpc.start
    local called = false

    vim.lsp.rpc.start = function(cmd, dispatchers, opts)
      called = true
      assert.is_table(cmd)
      assert.equals('jdtls', cmd[1])
      return 'ok'
    end

    vim.cmd('edit test/test_dir/a/test.java')

    local result = jdtls.cmd({}, nil)

    assert.equals('ok', result)
    assert.is_true(called)

    vim.lsp.rpc.start = original_start
  end)
end)
