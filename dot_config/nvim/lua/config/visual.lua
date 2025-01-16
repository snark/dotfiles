-- We want this to happen *after* Treesitter setup to avoid
-- our colorscheme getting clobberred by Treesetter setup.
vim.o.signcolumn = 'yes'
vim.api.nvim_create_autocmd(
    'ColorScheme',
    {
        pattern = '*',
        callback = function()
            local base_hl = vim.api.nvim_get_hl_by_name('Comment', true)
            local ital = { italic = true }
            local italicized_hl = vim.tbl_extend('force', base_hl, ital)
            vim.api.nvim_set_hl(0, 'Comment', italicized_hl)
        end,
    }
)
vim.cmd.colorscheme('lunaperche')
