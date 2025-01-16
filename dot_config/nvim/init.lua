-- Built-in vim options, set leader
require("config.settings")
-- A couple useful autocmds
require("config.autocmds")
-- Bootstrap Lazy for plugin management
require("config.lazy")
-- Mappings, including ones for Telescope
require("config.mappings")
-- Set up our LSP tooling (linters etc)
require("config.lsp")
-- Display marks in the gutter
require("config.marks")
-- Set up rg for grep
require("config.grep")
-- Appearance: colorscheme, signcolumn, forced-italics comments
require("config.visual")
