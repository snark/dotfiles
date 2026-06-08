-- Hide search highlights after a few seconds; built-in plugin
vim.cmd("packadd nohlsearch")

-- We want this to happen *after* Treesitter setup to avoid
-- our colorscheme getting clobberred by Treesetter setup.
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        local base_hl = vim.api.nvim_get_hl_by_name("Comment", true)
        local ital = { italic = true }
        local italicized_hl = vim.tbl_extend("force", base_hl, ital)
        vim.api.nvim_set_hl(0, "Comment", italicized_hl)
    end,
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    pattern = { "lunaperche" },
    callback = function()
        -- Fix floating windows
        vim.cmd("highlight! link NormalFloat Normal")
        vim.cmd("highlight! link FloatBorder NormalFloat")
        if vim.opt.bg:get() == "light" then
            return
        end
        -- vim.api.nvim_set_hl(0, 'CurSearch', { fg = '#ffffff', bg = bg, underline = true, bold = true })
        -- vim.api.nvim_set_hl(0, 'Search', { fg = '#ffffff', bg = bg })
        -- also tried 336633 and 78a0b8
        vim.api.nvim_set_hl(0, "CurSearch", { bold = true, underline = true })
        vim.api.nvim_set_hl(0, "Search", { bold = true, bg = "#6c6c6c" })
    end,
})

vim.cmd.colorscheme("lunaperche")
