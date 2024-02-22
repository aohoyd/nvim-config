return {
  "aohoyd/broot.nvim",
  enabled = true,
  lazy = true,
  cmd = { "Broot", "BrootCurrentDir", "BrootWorkingDir", "BrootHomeDir", "BrootProjectDir" },
  init = function()
    require("broot.config").hijack_netrw()
  end,
  config = function(opts)
    if vim.o.background == "light" then
      opts.broot_conf_path = vim.fn.expand("~/.config/broot/conf.hjson")
        .. ";"
        .. vim.fn.expand("~/.config/broot/white-skin.hjson")
    end
    require("broot").setup(opts)
  end,
}
