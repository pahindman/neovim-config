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
  require("lspconfig").rust_analyzer.setup{}
else
  print('init.lua: lspconfig not found')
end
