#/usr/bin/env bash

set -e
set -o pipefail
set -o nounset


GITHUB_USERNAME="${GITHUB_USERNAME:-snark}"

echo "Bootstrapping this Mac; grab a cup of coffee?"

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until bootstrap has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install maxOS all available updates
echo "Updating macOS; if a restart is required, please rerun the bootstrap."
sudo softwareupdate -ia

if ! xcode-select -p >/dev/null 2>&1 ; then
    echo "Installing Xcode tools; this will take a while..."
    #xcode-select --install
else
    echo "Xcode tools are available."
fi

# We don't use `command -v` here because we're not assuming
# that brew is in our $PATH, due to the bootstrappiness.
if [ -f "/opt/homebrew/bin/brew" ]; then
    echo "Homebrew already installed. Getting updates..."
    #brew update
    #brew doctor
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

fi

eval $(/opt/homebrew/bin/brew shellenv)

if command -v chezmoi > /dev/null; then
    echo "chezmoi is installed."
else
    echo "Installing chezmoi..."
    brew install chezmoi
fi

if chezmoi managed | grep -q '.config'; then
  echo "chezmoi is managing .config already."
else
  echo "Loading dotfiles from $GITHUB_USERNAME repo..."
  chezmoi init $GITHUB_USERNAME
  chezmoi apply -v
fi

echo "Adding initial files from Brewfile..."
#brew bundle --file="$(chezmoi source-path)/extras/homebrew/Brewfile.initial"

echo "Applying a few default settings"
# First, back up the defaults as of now.
# See https://github.com/brokosz/macos-defaults/tree/main
datetime=`date +'%Y%m%d%H%M%S'`
output_dir="$HOME/Documents/defaults/$datetime"
mkdir -p "$output_dir"
# Display the output directory being used
echo "Logging current defaults to $output_dir..."
# Get all defaults domains
domains=$(defaults domains | tr -d ',')
for domain in $domains; do
    # Replace dots in domain with underscores for file naming
    sanitized_domain=$(echo "$domain" | tr '.' '_')
    output_file="$output_dir/$sanitized_domain.plist"
    # Export the domain settings as a plist file
    defaults export "$domain" "$output_file"
done
defaults read > "$output_dir/defaults.readable"

echo "Password required after screensaver activation."
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo ".DS_Store files disabled."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# We'll apply more defaults outside this bootstrap!

# Activate full-disk encryption.
echo "Checking full-disk encryption status..."
if fdesetup status | grep -q -E "FileVault is (On|Off, but will be enabled after the next restart)."; then
    echo "FileVault is active."
else
    echo "Enabling full-disk encryption on next reboot..."
      sudo fdesetup enable -user "$USER" |
    	tee ~/Desktop/"FileVault Recovery Key.txt"
fi

echo "Bootstrap complete! Now activate chezmoi and finish the loadout!"
