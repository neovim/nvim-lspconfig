local denols = dofile('lsp/denols.lua')

describe('denols root_dir', function()
  --- @diagnostic disable-next-line:undefined-field
  local eq = assert.are.equal
  local root
  local buffers

  before_each(function()
    root = vim.fn.tempname()
    buffers = {}
    vim.fn.mkdir(root, 'p')
  end)

  after_each(function()
    for _, bufnr in ipairs(buffers) do
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
    vim.fn.delete(root, 'rf')
  end)

  local function file(path)
    path = root .. '/' .. path
    vim.fn.mkdir(vim.fs.dirname(path), 'p')
    vim.fn.writefile({}, path)
  end

  local function find_root(path)
    file(path)
    local bufnr = vim.fn.bufadd(root .. '/' .. path)
    table.insert(buffers, bufnr)
    local found
    denols.root_dir(bufnr, function(dir)
      found = dir
    end)
    return found
  end

  it('does not attach without a Deno marker', function()
    file('.git/HEAD')
    eq(nil, find_root('src/main.ts'))
  end)

  for _, marker in ipairs({ 'deno.json', 'deno.jsonc', 'deno.lock' }) do
    it('attaches to a standalone ' .. marker .. ' project', function()
      file(marker)
      eq(root, find_root('src/main.ts'))
    end)
  end

  for _, marker in ipairs({ 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }) do
    it('does not attach to a ' .. marker .. ' project inside a Deno project', function()
      file('deno.json')
      file('node/' .. marker)
      eq(nil, find_root('node/src/main.ts'))
    end)

    it('attaches to a Deno project inside a ' .. marker .. ' project', function()
      file(marker)
      file('deno/deno.json')
      eq(root, find_root('deno/src/main.ts'))
    end)

    it('attaches when deno.json is beside ' .. marker, function()
      file(marker)
      file('deno.json')
      eq(root, find_root('src/main.ts'))
    end)

    it('does not attach when only deno.lock is beside ' .. marker, function()
      file(marker)
      file('deno.lock')
      eq(nil, find_root('src/main.ts'))
    end)

    it('attaches when deno.lock is closer than ' .. marker, function()
      file(marker)
      file('deno/deno.lock')
      eq(root, find_root('deno/src/main.ts'))
    end)
  end

  it('distinguishes nested Deno, Node, and Deno projects', function()
    file('.git/HEAD')
    file('deno.json')
    file('deno.lock')
    file('npmproject/package-lock.json')
    file('npmproject/package.json')
    file('npmproject/packages/denoproject/deno.json')
    eq(root, find_root('src/main.ts'))
    eq(nil, find_root('npmproject/src/main.ts'))
    eq(root .. '/npmproject', find_root('npmproject/packages/denoproject/src/main.ts'))
  end)
end)
