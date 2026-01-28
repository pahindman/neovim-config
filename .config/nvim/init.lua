-- Pull in .vimrc and Vim plugins
vim.opt.runtimepath:prepend('~/.vim')
vim.opt.runtimepath:append('~/.vim/after')
vim.o.packpath = vim.o.runtimepath
vim.cmd('source ~/.vimrc')

require('gitsigns').setup {
  signs = {
    delete       = { show_count = true },
  },
  signs_staged = {
    delete       = { show_count = true },
  },
  linehl     = true, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = true, -- Toggle with `:Gitsigns toggle_word_diff`
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
    delay = 100,
  },
  current_line_blame_formatter = '<abbrev_sha>: <author>, <author_time:%R> - <summary>',
}

local codecompanion, _ = pcall(require, 'codecompanion')
if codecompanion then
  vim.lsp.config.codecompanion = {}
  vim.lsp.enable({"codecompanion"})
else
  print('init.lua: codecompanion not found')
end

-- Try to load the lspconfig plugin.  If that works then set up the LSP
-- servers, otherwise print a message.
local lspconfig, _ = pcall(require, 'lspconfig')
if lspconfig then
  vim.lsp.config.bashls = {}
  vim.lsp.enable({"bashls"})
  vim.lsp.config.clangd = {}
  vim.lsp.enable({"clangd"})
  vim.lsp.config.cmake = {}
  vim.lsp.enable({"cmake"})
  vim.api.nvim_create_autocmd('FileType', {
    pattern = "dts",
    callback = function (ev)
      vim.lsp.start({
        name = 'dts-lsp',
        cmd = {'dts-lsp'},
        root_dir = vim.fs.dirname(vim.fs.find({'.git'}, { upward = true })[1]),
      })
    end
  })
  vim.lsp.config.lua_ls = {
    on_init = function(client)
      local path = '.'
      if client.workspace_folders then
        path = client.workspace_folders[1].name
      end
      if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
        return
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT'
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            "${3rd}/luv/library"
            -- Depending on the usage, you might want to add additional paths here.
            -- "${3rd}/luv/library"
            -- "${3rd}/busted/library",
          }
          -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
          -- library = vim.api.nvim_get_runtime_file("", true)
        }
      })
    end,
    settings = {
      Lua = {}
    }
  }
  vim.lsp.enable({"lua_ls"})
  vim.lsp.config.rust_analyzer = {}
  vim.lsp.enable({"rust_analyzer"})
  vim.lsp.config.vimls = {}
  vim.lsp.enable({"vimls"})
  -- set keymap for code-action
  vim.keymap.set('n', '<space>ca', function()
    vim.lsp.buf.code_action({apply=true}) end, {})
else
  print('init.lua: lspconfig not found')
end

-- show vim diagnostics in virtual text
vim.diagnostic.config({
  virtual_text = true,
})
