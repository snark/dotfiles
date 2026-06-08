-- Currently in use  for real.
vim.pack.add({
    -- Telescope fuzzy-finder
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    -- Autodetect indent setup by buffer filetype
    "https://github.com/tpope/vim-sleuth",
    -- . repeats behavior (utility library used by other things)
    "https://github.com/tpope/vim-repeat",
    -- Add git indicators to the gutter
    "https://github.com/lewis6991/gitsigns.nvim",
    -- Surround-selection improvement
    -- e.g.: ysiw) / ds] / cs'" / dsf
    "https://github.com/kylechui/nvim-surround",
    -- Movement utility library; subsumes clever-f, which I used previously
    "https://codeberg.org/andyg/leap.nvim",
    -- Quickfix UX improvements
    "https://github.com/stevearc/quicker.nvim",
    -- Indent level visualizer
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    -- Keybinding helper
    "https://github.com/folke/which-key.nvim",
    -- Used by some third-party libraries
    "https://github.com/nvim-tree/nvim-web-devicons",
})

require("gitsigns").setup()
require("nvim-web-devicons").setup()

require("ibl").setup({
    indent = {
        char = "┊",
        tab_char = "┊",
    },
})

-- This Leap configuration gives ranged targeting, a la hop, as well as the
-- clever-f behavior I expect to repeat without use of ;.
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
vim.keymap.set("n", "S", "<Plug>(leap-from-window)")
require("leap").opts.safe_labels = ""

do
    local function ft(key_specific_args)
        require("leap").leap(vim.tbl_deep_extend("keep", key_specific_args, {
            inputlen = 1,
            inclusive = true,
            opts = {
                -- Force autojump.
                labels = "",
                -- Match the modes where you don't need labels (`:h mode()`).
                safe_labels = vim.fn.mode(1):match("o") and "" or nil,
            },
        }))
    end

    -- A helper function making it easier to set "clever-f" behavior
    -- (using f/F or t/T instead of ;/, - see the plugin clever-f.vim).
    local clever = require("leap.user").with_traversal_keys
    local clever_f, clever_t = clever("f", "F"), clever("t", "T")

    vim.keymap.set({ "n", "x", "o" }, "f", function()
        ft({ opts = clever_f })
    end)
    vim.keymap.set({ "n", "x", "o" }, "F", function()
        ft({ backward = true, opts = clever_f })
    end)
    vim.keymap.set({ "n", "x", "o" }, "t", function()
        ft({ offset = -1, opts = clever_t })
    end)
    vim.keymap.set({ "n", "x", "o" }, "T", function()
        ft({ backward = true, offset = 1, opts = clever_t })
    end)
end

-- TODO: LazyLoad this via autocmd
require("which-key").setup({
    preset = "helix", -- Options: classic, modern, helix (v3+)
    delay = 500,
    triggers = {
        { "<auto>", mode = "nxso" },
    },
})
vim.keymap.set("n", "<leader>?", function()
    require("which-key").show()
end)

require("quicker").setup()
vim.keymap.set("n", "<leader>q", function()
    require("quicker").toggle()
end, {
    desc = "Toggle quickfix",
})
vim.keymap.set("n", "<leader>ll", function()
    require("quicker").toggle({ loclist = true })
end, {
    desc = "Toggle loclist",
})
require("quicker").setup({
    keys = {
        {
            ">",
            function()
                require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
            end,
            desc = "Expand quickfix context",
        },
        {
            "<",
            function()
                require("quicker").collapse()
            end,
            desc = "Collapse quickfix context",
        },
    },
})

-- Colorschemes!
--
-- Some dark themes; I'm mostly happy with the built-in lunaperche these days,
-- although my heart will always belong to jellybeans.
vim.pack.add({ "https://github.com/WTFox/jellybeans.nvim" })
vim.pack.add({ "https://github.com/daviii-lopes/pureblack.nvim" })
vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })
