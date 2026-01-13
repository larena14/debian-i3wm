#!/bin/bash

sudo apt install --no-install-recommends -y sddm
sudo apt install -y i3 nano wget gpg curl git pulseaudio pavucontrol apt-transport-https pasystray \
                    zip unzip p7zip-full alacritty tmux zsh tealdeer network-manager network-manager-applet nm-connection-editor blueman pulseaudio-module-bluetooth \
                    arandr nemo evince caffeine grub-customizer flameshot

# start and enable sddm

sudo systemctl start sddm
sudo systemctl enable sddm

# stop and disable systemd-networkd

sudo systemctl stop systemd-networkd.service
sudo systemctl disable systemd-networkd.service

# start and enable NetworkManager

sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager

# install sublime

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update && sudo apt install -y sublime-text
touch ~/.config/sublime-text/Packages/User/Preferences.sublime-settings
tee ~/.config/sublime-text/Packages/User/Preferences.sublime-settings > /dev/null <<'EOF'
// Settings in here override those in "Default/Preferences.sublime-settings",
// and are overridden in turn by syntax-specific settings.
{
        "remember_workspace": false,
        "open_files_in_new_window": "always",
        "remember_open_files": false
}
EOF

# install google-chrome

sudo wget -q -O /etc/apt/keyrings/linux_signing_key.pub https://dl-ssl.google.com/linux/linux_signing_key.pub

sudo tee /etc/apt/sources.list.d/google-chrome.sources > /dev/null <<'EOF'
Types: deb
URIs: http://dl.google.com/linux/chrome/deb/
Suites: stable
Components: main
Architectures: amd64
Signed-By: /etc/apt/keyrings/linux_signing_key.pub
EOF

sudo apt update && sudo apt install -y google-chrome-stable

# set zsh

echo "# Created by newuser" > ~/.zshrc
sudo chsh -s $(which zsh) $USER
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# set alacritty configuration

mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

tee  ~/.config/alacritty/alacritty.toml > /dev/null <<'EOF'
[general]
import = [ "~/.config/alacritty/alacritty-theme/themes/nord.toml" ]

[terminal.shell]
program = "/bin/zsh"
args = [ "-l", "-c", "tmux" ]

[window]
opacity = 1
dynamic_padding = true
title = "Alacritty"

[window.padding]
x = 3
y = 3

[window.class]
instance = "Alacritty"
general = "Alacritty"

[scrolling]
history = 10_000

[font]
size = 12
EOF
