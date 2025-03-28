Files in this directory and below are not for use with `chezmoi`.

To bootstrap a new Mac (installing xcode tools, homebrewm, and
chezmoi and grabbing dotfiles from Github, run the following:

```
bash <(curl -Ls https://raw.githubusercontent.com/snark/dotfiles/refs/heads/master/extras/bootstrap.sh)
```

Once that's done, open a new terminal window (Alacritty will be
installed) and run `chezmoi apply -v` to activate dotfiles. The
full set of applications can be installed and additional setup
performed with `loadout.sh`, sound in the `scripts/` directory.

Note that neither the bootscript nor the loadout script currently
handle getting SSH keys or my KeePass vault.
