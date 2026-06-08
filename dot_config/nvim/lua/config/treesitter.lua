-- Note that as of 0.12, use of nvim's treesitter is dependent on installing the
-- tree-sitter CLI tooling; in Homebrew, that's `tree-sitter-cli` and not simply
-- `tree-sitter`.
--
-- nvim-treesetter has been EOLed, so we're going to try the WASM `arborist`
-- plugin instead. neovim must have been compiled with WASM support to use this.
-- There's an open issue to move the nvim-treesitter/arborist-ts behavior into
-- core neovim, so this may eventually be mooted:
-- https://github.com/neovim/neovim/issues/39006
--
-- There's also the more minimalist https://github.com/so1ve/tiny-treesitter.nvim;
-- this is clearly a space in flux and I should check back at some point (but will
-- probably forget for years).
vim.pack.add({
    "https://github.com/arborist-ts/arborist.nvim",
})
if vim.fn.has("wasi") == 1 and vim.fn.executable("tree-sitter") == 1 then
    require("arborist").setup({
        update_cadence = "weekly",
    })
end
