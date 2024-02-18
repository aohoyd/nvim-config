return {
  "nvim-treesitter/nvim-treesitter",
  keys = {
    -- { "<c-space>", false },
    -- { "<bs>", false },
    { "<M-up>", desc = "Increment selection" },
    { "<M-down>", desc = "Decrement selection", mode = "x" },
  },
  opts = {
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<M-up>",
        node_incremental = "<M-up>",
        scope_incremental = false,
        node_decremental = "<M-down>",
      },
    },
  },
}
