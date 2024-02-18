-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.list = false
vim.opt.listchars = {
  tab = "▸ ",
  eol = "¶",
  trail = "-",
  nbsp = "+",
}
vim.opt.showtabline = 0
vim.opt.guifont = "Mono Lisa:16"

vim.g.neovide_input_macos_alt_is_meta = true
