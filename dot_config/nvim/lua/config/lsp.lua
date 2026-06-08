-- The full stack of nvim-lspconfig, mason, mason-lspconfig, and mason-tool-installer,
-- to provide LSPs for various languages, plus conform (to provide linter support).
--
-- https://dotfiles.substack.com/p/native-lsp-in-neovim-012
-- https://dev.to/mochafreddo/configuring-neovim-with-initlua-a-comprehensive-guide-2a7i
vim.diagnostic.config({
    signs = true,
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
})

-- Mason must be installed first, then nvim-lspconfig, then mason-lspconfig.
vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
})
require("mason").setup()

vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/stevearc/conform.nvim",
})

require("mason-lspconfig").setup()

local lsp_cmds = vim.api.nvim_create_augroup("lsp_cmds", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_cmds,
    desc = "LSP actions",
    callback = function()
        local bufmap = function(mode, lhs, rhs, description)
            local args = { buffer = true }
            local desc = description or ""
            if desc ~= "" then
                args.desc = desc
            end
            vim.keymap.set(mode, lhs, rhs, args)
        end

        bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
        bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition of symbol")
        bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration of symbol (less supported)")
        bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implemenation of symbol")
        bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to type definition of symbo")
        bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", "Go to code references")
        bufmap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Show signature help")
        bufmap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", "LSP rename")
        bufmap({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "LSP formatter")
        bufmap("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Select an LSP code action")
        bufmap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", "Open LSP diagnostic")
        bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Go to previous LSP diagnostic")
        bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", "Go to next LSP diagnostic")
    end,
})

vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "cursor",
        }
        vim.diagnostic.open_float(nil, opts)
    end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false })
    end,
})

-- Show all diagnostics on current line in floating window
vim.api.nvim_set_keymap(
    "n",
    "<Leader>d",
    ":lua vim.diagnostic.open_float()<CR>",
    { desc = "Open LSP diagnostic", noremap = true, silent = true }
)
-- Go to next diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
vim.api.nvim_set_keymap(
    "n",
    "<Leader>n",
    ":lua vim.diagnostic.goto_next()<CR>",
    { desc = "Go to next LSP diagnostic", noremap = true, silent = true }
)
-- Go to prev diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
vim.api.nvim_set_keymap(
    "n",
    "<Leader>p",
    ":lua vim.diagnostic.goto_prev()<CR>",
    { desc = "Go to previous diagnostic", noremap = true, silent = true }
)

vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

vim.keymap.set("n", "<leader>xd", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})

local conform = require("conform")
conform.setup({
    formatters = {
        stylua = {
            args = {
                "--search-parent-directories",
                "--indent-type",
                "Spaces",
                "--stdin-filepath",
                "$FILENAME",
                "-",
            },
        },
    },
    formatters_by_ft = {
        css = { "prettier" },
        go = { "goimports", "gofmt" },
        html = { "prettier" },
        javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
        json = { "biome", "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        python = { "isort", "ruff" },
        rust = { "rustfmt", lsp_format = "fallback" },
        typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
        toml = { "taplo" },
    },
    format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { timeout_ms = 500, lsp_fallback = true }
    end,
})
