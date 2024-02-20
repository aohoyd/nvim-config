return {
  { "catppuccin/nvim" },
  { "navarasu/onedark.nvim", opts = { style = "light" } },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
