local function comment_selection(selection)
  local len = #vim.api.nvim_buf_get_lines(0, selection.row, selection.row + 1, false)[1]
  MiniComment.toggle_lines(selection.row + 1, selection.end_row + 1, nil)
  local new_len = #vim.api.nvim_buf_get_lines(0, selection.row, selection.row + 1, false)[1]

  local diff = new_len - len

  return {
    id = selection.id,
    row = selection.row,
    end_row = selection.end_row,
    col = selection.col + diff,
    end_col = selection.end_col + diff,
  }
end

local comment = {
  method = function()
    local U = require("multicursors.utils")
    local selections = U.get_all_selections()
    for _, selection in ipairs(selections) do
      U.delete_extmark(selection, U.namespace.Multi)
      local commented = comment_selection(selection)
      U.create_extmark(commented, U.namespace.Multi)
    end

    local main = U.get_main_selection()
    U.delete_extmark(main, U.namespace.Main)
    local commented = comment_selection(main)
    U.create_extmark(commented, U.namespace.Main)
    U.move_cursor({ commented.row + 1, commented.end_col - 1 })
  end,
  opts = { desc = "comment selections" },
}

return {
  "smoka7/multicursors.nvim",
  lazy = true,
  event = "VeryLazy",
  dependencies = {
    "smoka7/hydra.nvim",
  },
  opts = {
    normal_keys = {
      ["gc"] = comment,
      ["<D-/>"] = comment,
      ["<D-g>"] = {
        method = function()
          require("multicursors.normal_mode").find_next()
        end,
        opts = { desc = "next" },
      },
    },
  },
  cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
  keys = {
    {
      mode = { "v", "n" },
      desc = "Create a selection for selected text or word under the cursor",
      "<D-g>",
      "<cmd>MCstart<cr>",
    },
    {
      mode = { "v", "n" },
      desc = "Create a selection for selected text or word under the cursor",
      "<leader>m",
      "<cmd>MCstart<cr>",
    },
  },
}
