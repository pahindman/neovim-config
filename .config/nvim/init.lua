-- Pull in .vimrc and Vim plugins
vim.opt.runtimepath:prepend('~/.vim')
vim.opt.runtimepath:append('~/.vim/after')
vim.o.packpath = vim.o.runtimepath
vim.cmd('source ~/.vimrc')

-- Try to load the lspconfig plugin.  If that works then set up the LSP
-- servers, otherwise print a message.
local lspconfig, _ = pcall(require, 'lspconfig')
if lspconfig then
  require("lspconfig").clangd.setup{}
  require("lspconfig").lua_ls.setup {
    on_init = function(client)
	  if client.workspace_folders then
        local path = client.workspace_folders[1].name
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
  require("lspconfig").rust_analyzer.setup{}
else
  print('init.lua: lspconfig not found')
end
