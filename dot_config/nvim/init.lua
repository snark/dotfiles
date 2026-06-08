-- Built-in vim options, set leader
require("config.settings")
-- -- A couple useful autocmds
require("config.autocmds")
-- Mappings, including ones for Telescope
require("config.mappings")
-- Treesitter
require("config.treesitter")
-- Set up our LSP tooling (including linters)
require("config.lsp")
-- Display marks in the gutter
require("config.marks")
-- Set up rg for grep
require("config.grep")
-- Undotree behavior
require("config.undo")
-- Plugins not handled elsewhere
require("config.plugins")
-- Appearance: colorscheme, forced-italics comments
require("config.visual")
