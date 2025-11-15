---@brief
---
--- GitLab Duo Language Server Configuration for Neovim
---
--- https://gitlab.com/gitlab-org/editor-extensions/gitlab-lsp
---
--- The GitLab LSP enables any editor or IDE to integrate with GitLab Duo
--- for AI-powered code suggestions via the Language Server Protocol.
---
--- Prerequisites:
--- - Node.js and npm installed
--- - GitLab account with Duo Pro license
--- - Internet connection for OAuth device flow
---
--- Setup:
--- 1. Run :LspGitLabDuoSignIn to start OAuth authentication
--- 2. Follow the browser prompts to authorize
--- 3. Enable inline completion in LspAttach event (see example below)
---
--- Inline Completion Example:
--- ```lua
--- vim.api.nvim_create_autocmd('LspAttach', {
---   callback = function(args)
---     local bufnr = args.buf
---     local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
---
---     if vim.lsp.inline_completion and
---        client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
---       vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
---
---       -- Tab to accept suggestion
---       vim.keymap.set('i', '<Tab>', function()
---         if vim.lsp.inline_completion.is_visible() then
---           return vim.lsp.inline_completion.accept()
---         else
---           return '<Tab>'
---         end
---       end, { expr = true, buffer = bufnr, desc = 'GitLab Duo: Accept suggestion' })
---
---       -- Alt/Option+[ for previous suggestion
---       vim.keymap.set('i', '<M-[>', vim.lsp.inline_completion.select_prev,
---         { buffer = bufnr, desc = 'GitLab Duo: Previous suggestion' })
---
---       -- Alt/Option+] for next suggestion
---       vim.keymap.set('i', '<M-]>', vim.lsp.inline_completion.select_next,
---         { buffer = bufnr, desc = 'GitLab Duo: Next suggestion' })
---     end
---   end
--- })
--- ```

-- Configuration
local config = {
  gitlab_url = 'https://gitlab.com',
  -- This is a oauth application created from tachyons-gitlab account with `api` scope
  client_id = '00bb391f527d2e77b3467b0b6b900151cc6a28dcfb18fa1249871e43bc3e5832',
  scopes = 'api',
  token_file = vim.fn.stdpath('data') .. '/gitlab_duo_oauth.json',
}

-- Helper function to make POST requests with curl via vim.system
local function curl_post(url, data, headers)
  local curl_args = {
    'curl',
    '-s',
    '-w',
    '\n%{http_code}',
    '-X',
    'POST',
    url,
  }

  -- Add headers
  for key, value in pairs(headers or {}) do
    table.insert(curl_args, '-H')
    table.insert(curl_args, key .. ': ' .. value)
  end

  -- Add data
  if data then
    table.insert(curl_args, '-d')
    table.insert(curl_args, data)
  end

  local result = vim.system(curl_args, { text = true }):wait()

  -- Split body and status code
  local output = result.stdout or ''
  local body_end = output:match('.*\n()%d+$')

  local body = ''
  local status = 0

  if body_end then
    body = output:sub(1, body_end - 2) -- -2 to remove trailing newline
    status = tonumber(output:match('\n(%d+)$')) or 0
  else
    body = output
  end

  return {
    status = status,
    body = body,
  }
end

-- Token management
local function save_token(token_data)
  token_data.saved_at = os.time()
  local file = io.open(config.token_file, 'w')
  if file then
    file:write(vim.json.encode(token_data))
    file:close()
    return true
  end
  return false
end

local function load_token()
  if vim.fn.filereadable(config.token_file) == 0 then
    return nil
  end

  local blob = vim.fn.readblob(config.token_file)
  return vim.json.decode(blob)
end

local function is_token_expired(token_data)
  if not token_data or not token_data.saved_at or not token_data.expires_in then
    return true
  end
  local token_age = os.time() - token_data.saved_at
  return token_age >= (token_data.expires_in - 60) -- 60 second buffer
end

local function refresh_access_token(refresh_token)
  vim.notify('Refreshing GitLab OAuth token...', vim.log.levels.INFO)

  local response = curl_post(
    config.gitlab_url .. '/oauth/token',
    string.format('client_id=%s&refresh_token=%s&grant_type=refresh_token', config.client_id, refresh_token),
    { ['Content-Type'] = 'application/x-www-form-urlencoded' }
  )

  if response.status ~= 200 then
    vim.notify('Failed to refresh token: ' .. (response.body or 'Unknown error'), vim.log.levels.ERROR)
    return nil
  end

  local ok, body = pcall(vim.json.decode, response.body)
  if not ok or not body.access_token then
    vim.notify('Invalid refresh response', vim.log.levels.ERROR)
    return nil
  end

  save_token(body)
  vim.notify('Token refreshed successfully', vim.log.levels.INFO)
  return body
end

local function get_valid_token()
  local token_data = load_token()

  if not token_data then
    return nil, 'no_token'
  end

  if is_token_expired(token_data) then
    if token_data.refresh_token then
      local new_token_data = refresh_access_token(token_data.refresh_token)
      if new_token_data then
        return new_token_data.access_token, 'refreshed'
      end
      return nil, 'refresh_failed'
    end
    return nil, 'expired'
  end

  return token_data.access_token, 'valid'
end

-- OAuth Device Flow
local function device_authorization()
  local response = curl_post(
    config.gitlab_url .. '/oauth/authorize_device',
    string.format('client_id=%s&scope=%s', config.client_id, config.scopes),
    { ['Content-Type'] = 'application/x-www-form-urlencoded' }
  )

  if response.status ~= 200 then
    vim.notify('Device authorization failed: ' .. response.status, vim.log.levels.ERROR)
    return nil
  end

  local data = vim.json.decode(response.body)

  return data
end

local function poll_for_token(device_code, interval, client)
  local max_attempts = 60
  local attempts = 0

  local function poll()
    attempts = attempts + 1

    local response = curl_post(
      config.gitlab_url .. '/oauth/token',
      string.format(
        'client_id=%s&device_code=%s&grant_type=urn:ietf:params:oauth:grant-type:device_code',
        config.client_id,
        device_code
      ),
      { ['Content-Type'] = 'application/x-www-form-urlencoded' }
    )

    local ok, body = pcall(vim.json.decode, response.body)
    if not ok then
      vim.notify('Failed to parse token response', vim.log.levels.ERROR)
      return
    end

    if response.status == 200 and body.access_token then
      save_token(body)
      vim.notify('GitLab Duo authentication successful!', vim.log.levels.INFO)

      -- Update LSP with new token
      vim.schedule(function()
        client:notify('workspace/didChangeConfiguration', {
          settings = {
            token = body.access_token,
            baseUrl = config.gitlab_url,
          },
        })
      end)
      return
    end

    if body.error == 'authorization_pending' then
      if attempts < max_attempts then
        vim.defer_fn(poll, interval * 1000)
      else
        vim.notify('Authorization timed out', vim.log.levels.ERROR)
      end
    elseif body.error == 'slow_down' then
      vim.defer_fn(poll, (interval + 5) * 1000)
    elseif body.error == 'access_denied' then
      vim.notify('Authorization denied', vim.log.levels.ERROR)
    elseif body.error == 'expired_token' then
      vim.notify('Device code expired. Please run :LspGitLabDuoSignIn again', vim.log.levels.ERROR)
    else
      vim.notify('OAuth error: ' .. (body.error or 'unknown'), vim.log.levels.ERROR)
    end
  end

  poll()
end

---@param client vim.lsp.Client
local function sign_in(client)
  vim.notify('Starting GitLab device authorization...', vim.log.levels.INFO)

  local auth_data = device_authorization()
  if not auth_data then
    return
  end

  vim.ui.open(auth_data.verification_uri .. '?user_code=' .. auth_data.user_code)

  poll_for_token(auth_data.device_code, auth_data.interval or 5, client)
end

---@param client vim.lsp.Client
local function sign_out(client)
  local ok = os.remove(config.token_file)
  if ok then
    vim.notify('Signed out. Token removed.', vim.log.levels.INFO)
    client:notify('workspace/didChangeConfiguration', {
      settings = { token = '' },
    })
  else
    vim.notify('Failed to remove token file', vim.log.levels.ERROR)
  end
end

local function show_status()
  local token_data = load_token()

  if not token_data then
    vim.notify('Not signed in. Run :LspGitLabDuoSignIn to authenticate.', vim.log.levels.INFO)
    return
  end

  local info = {
    'GitLab Duo Status:',
    '',
    'Instance: ' .. config.gitlab_url,
    'Signed in: Yes',
    'Has refresh token: ' .. (token_data.refresh_token and 'Yes' or 'No'),
  }

  if token_data.saved_at and token_data.expires_in then
    local time_left = token_data.expires_in - (os.time() - token_data.saved_at)
    if time_left > 0 then
      local hours = math.floor(time_left / 3600)
      local minutes = math.floor((time_left % 3600) / 60)
      table.insert(info, string.format('Token expires in: %dh %dm', hours, minutes))
    else
      table.insert(info, 'Token status: EXPIRED')
    end
  end

  vim.notify(table.concat(info, '\n'), vim.log.levels.INFO)
end

---@type vim.lsp.Config
return {
  cmd = {
    'npx',
    '--registry=https://gitlab.com/api/v4/packages/npm/',
    '@gitlab-org/gitlab-lsp',
    '--stdio',
  },
  root_markers = { '.git' },
  filetypes = {
    'ruby',
    'go',
    'javascript',
    'typescript',
    'typescriptreact',
    'javascriptreact',
    'rust',
    'lua',
    'python',
    'java',
    'cpp',
    'c',
    'php',
    'cs',
    'kotlin',
    'swift',
    'scala',
    'vue',
    'svelte',
    'html',
    'css',
    'scss',
    'json',
    'yaml',
  },
  init_options = {
    editorInfo = {
      name = 'Neovim',
      version = tostring(vim.version()),
    },
    editorPluginInfo = {
      name = 'Neovim LSP',
      version = tostring(vim.version()),
    },
    ide = {
      name = 'Neovim',
      version = tostring(vim.version()),
      vendor = 'Neovim',
    },
    extension = {
      name = 'Neovim LSP Client',
      version = tostring(vim.version()),
    },
  },
  settings = {
    baseUrl = config.gitlab_url,
    logLevel = 'info',
    codeCompletion = {
      enableSecretRedaction = true,
    },
    telemetry = {
      enabled = false,
    },
    featureFlags = {
      streamCodeGenerations = false,
    },
  },
  on_init = function(client)
    -- Handle token validation errors
    client.handlers['$/gitlab/token/check'] = function(_, result)
      if result and result.reason then
        vim.notify(string.format('GitLab Duo: %s - %s', result.reason, result.message or ''), vim.log.levels.ERROR)

        -- Try to refresh if possible
        local token_data = load_token()
        if token_data and token_data.refresh_token then
          vim.schedule(function()
            local new_token_data = refresh_access_token(token_data.refresh_token)
            if new_token_data then
              client:notify('workspace/didChangeConfiguration', {
                settings = { token = new_token_data.access_token },
              })
            else
              vim.notify('Run :LspGitLabDuoSignIn to re-authenticate', vim.log.levels.WARN)
            end
          end)
        else
          vim.notify('Run :LspGitLabDuoSignIn to authenticate', vim.log.levels.WARN)
        end
      end
    end

    -- Handle feature state changes
    client.handlers['$/gitlab/featureStateChange'] = function(_, result)
      if result and result.state == 'disabled' and result.checks then
        for _, check in ipairs(result.checks) do
          vim.notify(string.format('GitLab Duo: %s', check.message or check.id), vim.log.levels.WARN)
        end
      end
    end

    -- Check authentication status
    local token, status = get_valid_token()
    if not token then
      vim.notify('GitLab Duo: Not authenticated. Run :LspGitLabDuoSignIn to sign in.', vim.log.levels.WARN)
    elseif status == 'refreshed' then
      vim.notify('GitLab Duo: Token refreshed automatically', vim.log.levels.INFO)
    end
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspGitLabDuoSignIn', function()
      sign_in(client)
    end, { desc = 'Sign in to GitLab Duo with OAuth' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspGitLabDuoSignOut', function()
      sign_out(client)
    end, { desc = 'Sign out from GitLab Duo' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspGitLabDuoStatus', function()
      show_status()
    end, { desc = 'Show GitLab Duo authentication status' })
  end,
}
