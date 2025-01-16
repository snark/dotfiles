-- Base settings, partially cribbed from
--   https://github.com/brainfucksec/neovim-lua/tree/main/nvim/lua
--
-- Note that this came from my .vimrc; a bunch of these probably came from
-- tpope's vim-sensible, and therefore are already baked into nvim. I should
-- go through and edit them sometime.

-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local cmd = vim.cmd             -- execute Vim commands
local exec = vim.api.nvim_exec  -- execute Vimscript
local fn = vim.fn               -- call Vim functions
local g = vim.g                 -- global variables
local opt = vim.opt             -- global/buffer/windows-scoped options

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.clipboard:append('unnamedplus')  -- copy/paste to system clipboard
g.mapleader = ','                    -- change leader to a comma
g.maplocalleader = ','               -- change local leader to a comma
opt.mouse = 'a'                      -- enable mouse support

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.colorcolumn = '80'          -- line length marker at 80 columns
opt.cursorline = true           -- highlight current line
opt.foldmethod = 'marker'       -- enable folding (default 'foldmarker')
opt.joinspaces = false          -- Block double spaces with join
opt.list = true                 -- display whitespace
opt.listchars = {               -- whitespace definitions
    tab = "▸ ", trail = "¬" 
}
opt.number = true               -- show line number
opt.relativenumber = true       -- show relative number; with `number`,
                                -- we get hybrid line numbers.
opt.linebreak = true            -- wrap on word boundary
opt.ruler = true                -- display ruler in statusline
opt.rulerformat = [[%l,%c]]     -- ...as line,column
opt.showmatch = true            -- highlight matching parenthesis
opt.showcmd = true              -- show command in status line
opt.showmode = true             -- show mode in status line
opt.splitbelow = true           -- horizontal split to the bottom
opt.splitright = true           -- vertical split to the right
opt.termguicolors = true        -- enable 24-bit RGB colors
opt.ttyfast = true              -- smoother changes
opt.visualbell = true           -- disable bell in terminal

-----------------------------------------------------------
-- Regex/Search
-----------------------------------------------------------
opt.gdefault = true             -- regexes use g by default (add g to disable)
opt.ignorecase = true           -- ignore case letters when search
opt.smartcase = true            -- ignore lowercase for the whole pattern

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- disable builtins plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

-- disable nvim intro
opt.shortmess:append "sI"

-- colorcolumn
cmd([[hi ColorColumn ctermbg=darkgray guibg=gray20]])
