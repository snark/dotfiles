# Dotfiles

This is a set of dotfiles to be managed by [chezmoi](https://www.chezmoi.io/),
representing a reasonably elaborate configuration focused on writing code in a
terminal window.

## zsh

The shell used is `zsh`, the current default for macOS use. A fairly minimalist
but reasonably attractive prompt will display time, directory, and git branch
(but not dirty/non-dirty status). Keybindings are vi-style, with a few
additions.

History is set up to be universally logged (locally rather than
network synced) via `atuin` when installed; CTRL-R for history search, CTRL-T
for file search, and `**` expansion are handled by `fzf`. `mise` has replaced
`direnv` (for local `.env` file control of enviromental variables) and
`nvm`/`pyenv` (for managing multiple versions of Python and Node).

`tmux` will autostart (using the session `BASE` if it is not in use or not
attached, and using a timestamped session name otherwise) on session start.

I've gone to some effort (including caching a number of scripts) to try to make
the time to first prompt reasonably quick, but `mise`'s overhead seems pretty
hard to avoid currently. Opening new panes in `tmux` is fairly quick.

## tmux

`tmux` is set to use the `tpm` plugin manager. CTRL-I after a new installation
will install them; I'm not currently using either `tmux-continuum` or
`tmux-resurrect`, but I go back and forth on this one.

The terminal is declared as `tmux-256color` to ensure that we have access to italics.

## neovim

`nvim` is configured with a number of keybindings that I've been using for
absolutely ages. This is the configuration that gets the most messing around,
as plugins go in, get fiddled with, and get thrown away.

The current setup uses what seems to be (as of January 2025), the most robust
LSP ecosystem, using `nvim-lspconfig`, `mason`, `nvim-lint`, and `conform` for
formatting. (No autocomplete plugin is in use; we rely on the built-in omnifunc
and some keybindings.) It's hard to say that this is lightweight, but it's
recognizable to me as good old vim. `lazy` is my current plugin manager. I'm
still using `clever-f` rather than `sneak` or `leap` or any other crazy motion
controls, but I use Telescope extensively and there are a number of bindings.

## ...and the rest...

A number of other programs---for instance the modal text editor `helix` or the
markdown previewer `glow`---are on my computers but don't currently get use to
the extent that I want to be able to version control their dotfiles. A few have
their configs checked in but don't really merit further discussion are:

* `bat` (a syntax-aware pager)
* `git`
* `ph` (a KeePass CLI, for integration with `chezmoi`)
* `vim` (this is a perfectly usable .vimrc with no plugins in place, suitable
   for dropping onto a remote server or into a Docker container)

The GUI Mac applications Alacritty (my current terminal emulator) and Rectangle
(a window manager) have their config files in this repo for good measure.
(Karabiner has been replaced with Hyperkey, a more focused application that
uses macOS defaults rather than a dotfiles system.
