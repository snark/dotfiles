local map = vim.api.nvim_set_keymap
local kset = vim.keymap.set

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- jj is escape--mostly useful on computers where caps lock hasn't been
-- remapped but there is no physical escape key. I've been using this for
-- decades and am baffled when it doesn't work out of the box.
map('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- Use `zz` for recentering after "H" and "L", allowing rapid movement.
kset({'n', 'x'}, 'H', 'Hzz', { noremap = true })
kset({'n', 'x'}, 'L', 'Lzz', { noremap = true })

-- Hide highlights after search with space
map('n', '<Space>', ':nohlsearch<Bar>:echo<CR>', { noremap = true, silent = true })

-- Semicolon works as colon
map('n', ';', ':', { noremap = true, silent = true })

-- Q to open the quickfix panel
map('n', 'Q', ':copen<CR>', { noremap = true, silent = true })

-- Vertical split controls (original due to Steve Losh, I believe?)
map('n', '<leader>w', '<C-w>v<C-w>l', { noremap = true })    -- ,w opens vertical split and switches to it
map('n', '<leader>s', '<C-w>v<C-w>s', { noremap = true })    -- ,h opens horizontal split and switches to it
map('n', '<C-h>', '<C-w>h', { noremap = true })              -- Control-<vim navigation> to navigate split panels
map('n', '<C-j>', '<C-w>j', { noremap = true })
map('n', '<C-k>', '<C-w>k', { noremap = true })
map('n', '<C-l>', '<C-w>l', { noremap = true })

-- Strip whitespace
map('n', '<leader>W', [[:%s/\s\+$//<CR>:let @/=''<CR>]], { noremap = true })
-- Turn colorcolumn on and off
map('n', '<leader>c',
   ':execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>',
   { silent = true, noremap = true })

-- A handrolled smartab function.
-- * When the cursor is at line-start or whitespace, insert a tab.
-- * Otherwise, if the completion popup is visible, choose the next item (I
--   may at some point switch this back to <C-y> to accept the item).
-- * If that isn't the case, open omnifunc.
local function omnitab()
   -- col is 0-indexed
   local col = vim.api.nvim_win_get_cursor(0)[2]
   if col == 0 then
      return '<Tab>'
   else
      local char = vim.api.nvim_get_current_line():sub(col,col)
      if char == ' ' or char == '\t' then
        return '<Tab>'
      else
        return vim.fn.pumvisible() == 1 and '<C-n>' or '<C-x><C-o>'
      end
   end
end
kset('i', '<Tab>', omnitab, {expr = true})

-- Less complex logic for shift-tab:
-- * If the popup is visible, choose the previous item.
-- * Otherwise, open the omnifunc popup.
kset('i', '<S-Tab>',
   function() return vim.fn.pumvisible() == 1 and '<C-p>' or '<C-x><C-o>' end,
   {expr = true})

-- Telescope bindings.
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
map('n', '<leader>fF', '<cmd>Telescope oldfiles<cr>', { noremap = true })
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })
map('n', '<leader>fj', '<cmd>Telescope jumplist<cr>', { noremap = true })
map('n', '<leader>fl', '<cmd>Telescope loclist<cr>', { noremap = true })
map('n', '<leader>fm', '<cmd>Telescope marks<cr>', { noremap = true })
map('n', '<leader>fr', '<cmd>Telescope registers<cr>', { noremap = true })
map('n', '<leader>ld', '<cmd>Telescope diagnostics bufnr=0<cr>', { noremap = true })
map('n', '<leader>lw', '<cmd>Telescope diagnostics<cr>', { noremap = true })

kset({'n', 'x'}, '<leader>8', '<cmd>Telescope grep_string word_match=-w<cr>', { noremap =  true })
