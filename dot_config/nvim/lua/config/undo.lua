-- Undo behavior
-- Native undo tree
-- Persistent undo
-- Convenience Undoclear command
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
-- Built into nvim 0.12, but must be explicitly added
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", function()
    require("undotree").open({
        command = math.floor(vim.api.nvim_win_get_width(0) / 3) .. "vnew",
    })
end, { desc = "Undotree toggle" })
vim.api.nvim_create_user_command("Undoclear", function()
    vim.cmd([[let old_ul = &l:undolevels]])
    vim.cmd([[setlocal undolevels=-1]])
    vim.cmd([[execute "normal! a \<BS>\<Esc>"]])
    vim.cmd([[let &l:undolevels = old_ul]])
end, { desc = "Clear undo history", nargs = 0 })
