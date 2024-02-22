-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- Toggle word wrap
vim.keymap.set({ "n", "v", "i" }, "<M-z>", function()
  vim.wo.wrap = not vim.wo.wrap
end, { silent = true })
vim.keymap.set({ "n", "v", "i" }, "Ω", function()
  vim.wo.wrap = not vim.wo.wrap
end, { silent = true })

-- Toggle list
vim.keymap.set({ "n", "v", "i" }, "<M-l>", function()
  vim.wo.list = not vim.wo.list
end, { silent = true })
vim.keymap.set({ "n", "v", "i" }, "¬", function()
  vim.wo.list = not vim.wo.list
end, { silent = true })

-- Telescope
local function telescope_browse_cwd()
  local cwd = vim.loop.cwd()
  vim.cmd("Telescope file_browser path=" .. cwd)
end

vim.keymap.set("n", "<leader>fl", function()
  vim.cmd("BrootProjectDir")
end, { desc = "Broot (root dir)" })
vim.keymap.set({ "n", "i", "v" }, "<D-l>", telescope_browse_cwd)

-- Save
vim.keymap.set({ "n", "i" }, "<D-s>", "<cmd>w<cr>", { silent = true }) -- Save

-- Copy/paste
vim.keymap.set("n", "<D-c>", "Vy") -- Copy line
vim.keymap.set("v", "<D-c>", "y") -- Copy selection
vim.keymap.set("n", "<D-x>", "Vd") -- Cut line
vim.keymap.set("v", "<D-x>", "d") -- Cut selection
vim.keymap.set({ "n", "v" }, "<D-v>", "P") -- Paste normal mode
vim.keymap.set({ "i", "c" }, "<D-v>", "<C-R>+") -- Paste command mode

-- Move lines
local function get_selection()
  local mode = vim.fn.mode()
  local _, row, col, _ = unpack(vim.fn.getpos("."))
  local start_row, start_col = row, col

  local is_visual = (mode == "v" or mode == "V" or mode == "")

  if is_visual then
    _, start_row, start_col, _ = unpack(vim.fn.getpos("v"))
  end

  return {
    mode = mode,
    is_visual = is_visual,
    row = row,
    col = col,
    start_row = start_row,
    start_col = start_col,
    top_row = math.min(start_row, row),
    bottom_row = math.max(start_row, row),
  }
end

local function insert(pos, dir, lines, keep)
  if pos.is_visual then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
  end

  local dest = pos.top_row + dir - 1
  if dir > 0 and keep then
    dest = pos.bottom_row + dir - 1
  end

  if not keep then
    vim.api.nvim_buf_set_lines(0, pos.top_row - 1, pos.bottom_row, false, {})
  end

  vim.api.nvim_buf_set_lines(0, dest, dest, false, lines)

  local shift = keep and dir * (pos.bottom_row - pos.top_row + 1) or dir

  if pos.is_visual then
    vim.api.nvim_win_set_cursor(0, { pos.start_row + shift, pos.start_col - 1 })
    vim.cmd("normal! " .. pos.mode)
  end
  vim.api.nvim_win_set_cursor(0, { pos.row + shift, pos.col - 1 })
end

local function send_lines(dir, keep)
  local pos = get_selection()

  if
    not keep and ((dir < 0 and pos.top_row == 1) or (dir > 0 and pos.bottom_row == vim.api.nvim_buf_line_count(0)))
  then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, pos.top_row - 1, pos.bottom_row, true)

  insert(pos, dir, lines, keep)
end

vim.keymap.set({ "n", "v" }, "<M-S-Up>", function()
  send_lines(-1, false)
end)

vim.keymap.set({ "n", "v" }, "<M-S-Down>", function()
  send_lines(1, false)
end)

-- Duplicate lines
vim.keymap.set({ "n", "v" }, "<D-d>", function()
  send_lines(1, true)
end)

-- Close
vim.keymap.set({ "n", "i", "v" }, "<D-w>", "<cmd>q<cr>")
vim.keymap.set({ "n", "i", "v" }, "<D-q>", "<cmd>qall<cr>")

-- Comment
vim.keymap.set({ "n", "i", "v" }, "<D-/>", "<cmd>normal gcc<cr>")

-- Select
vim.keymap.set({ "n", "i" }, "<D-a>", "<cmd>normal ggVG<cr>")

-- Buffers
vim.keymap.set({ "n", "v", "i" }, "<C-Tab>", "<cmd>bp<cr>")
vim.keymap.set({ "n", "v", "i" }, "<C-S-Tab>", "<cmd>bn<cr>")
